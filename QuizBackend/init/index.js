const mongoose = require("mongoose");
const initData = require("./data.js");
const Question = require("../Model/Question.js");

const MONGO_URL = 'mongodb://127.0.0.1:27017/QuizApp';

main().then(()=>{
  console.log("Connected to DB");
  
})
.catch((err)=>{
  console.log(err);
  
})

async function main (){
  await mongoose.connect(MONGO_URL);
}

const initDB = async ()=>{
  await Question.deleteMany({});
  await Question.insertMany(initData.data);
  console.log("data was initialized");
  
}

initDB();

