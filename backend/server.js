const express = require('express');
const cors = require('cors');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const app = express();
const db = new sqlite3.Database(path.join(__dirname, 'life_tracker.db'));
app.use(cors());
app.use(express.json());

db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT, role TEXT)`);
  db.run(`CREATE TABLE IF NOT EXISTS members (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, role TEXT, avatar TEXT)`);
  db.run(`CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, assignedTo INTEGER, status TEXT, priority TEXT, deadline TEXT)`);
  db.run(`INSERT OR IGNORE INTO users(id,name,email,password,role) VALUES (1,'Admin','admin@life.kz','admin123','admin'),(2,'User','user@life.kz','user123','member')`);
  db.run(`INSERT OR IGNORE INTO members(id,name,email,role,avatar) VALUES (1,'Admin','admin@life.kz','admin','👩🏻‍💻'),(2,'User','user@life.kz','member','🧑🏻‍🎓')`);
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  db.get('SELECT id,name,email,role FROM users WHERE email=? AND password=?', [email, password], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(401).json({ error: 'Invalid login or password' });
    res.json(row);
  });
});

app.get('/api/members', (_, res) => db.all('SELECT * FROM members ORDER BY id DESC', [], (err, rows) => err ? res.status(500).json({error: err.message}) : res.json(rows)));
app.post('/api/members', (req, res) => {
  const { name, email, role, avatar } = req.body;
  db.run('INSERT INTO members(name,email,role,avatar) VALUES(?,?,?,?)', [name, email, role || 'member', avatar || '🙂'], function(err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ id: this.lastID, name, email, role: role || 'member', avatar: avatar || '🙂' });
  });
});

app.get('/api/tasks', (_, res) => db.all('SELECT * FROM tasks ORDER BY id DESC', [], (err, rows) => err ? res.status(500).json({error: err.message}) : res.json(rows)));
app.post('/api/tasks', (req, res) => {
  const { title, description, assignedTo, priority, deadline } = req.body;
  db.run('INSERT INTO tasks(title,description,assignedTo,status,priority,deadline) VALUES(?,?,?,?,?,?)', [title, description || '', assignedTo, 'todo', priority || 'Medium', deadline || new Date().toISOString()], function(err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ id: this.lastID, title, description, assignedTo, status: 'todo', priority, deadline });
  });
});
app.patch('/api/tasks/:id/status', (req, res) => {
  db.run('UPDATE tasks SET status=? WHERE id=?', [req.body.status, req.params.id], function(err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ ok: true });
  });
});

app.listen(3000, () => console.log('Life Tracker backend running on http://localhost:3000'));
