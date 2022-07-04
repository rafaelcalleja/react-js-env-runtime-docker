import React from 'react';
import ReactDOM from 'react-dom/client';

const root = ReactDOM.createRoot(document.getElementById('root'));
const hello = process.env.REACT_APP_HELLO;
const world = process.env.REACT_APP_WORLD;
root.render(<h1>{ hello }, {world}</h1>);
