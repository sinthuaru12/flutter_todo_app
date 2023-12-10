const express = require('express');
const morgan = require('morgan');
const mongoose = require('mongoose');
const Todo = require('./models/todo')

const app = express();

app.use(morgan('dev'));

//Use to get resquest body
app.use(express.urlencoded({extended: true}));
app.use(express.json());

const dbUrl = 'mongodb://127.0.0.1:27017/demo';

mongoose.connect(dbUrl)
  .then(() => app.listen(3000));


app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
});
  
app.post('/add-todo', (req,res) =>{
    const todo = new Todo(req.body);
    todo.save(todo)
    .then(result => res.send(result))
    .catch(err => console.log(err))
});

app.get('/all-todos', (req,res) =>{
    Todo.find()
    .then(result => res.send({todos: result}))
    .catch(err => console.log(err))
});

app.get('/todo/:id', (req,res) =>{
    const id = req.params.id;
    Todo.findById(id)
    .then(result => res.send(result))
    .catch(err => console.log(err))
});

app.put('/todo/:id', (req,res) =>{
    const id = req.params.id;
    Todo.findByIdAndUpdate(id, req.body)
    .then(result => res.send(result))
    .catch(err => console.log(err))
});

app.delete('/todo/:id', (req,res) =>{
    const id = req.params.id;
    Todo.findByIdAndDelete(id)
    .then(result => res.send(result))
    .catch(err => console.log(err))
});