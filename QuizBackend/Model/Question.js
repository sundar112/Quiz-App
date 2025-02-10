const mongoose = require ("mongoose");
const Schema = mongoose.Schema;

const QuestionSchema = new Schema({
  category: { type: String, required: true },
  question: { type: String, required: true },
  options: { type: [String], required: true },
  correctAnswer: { type: String, required: true },
});

const Question = mongoose.model("Question", QuestionSchema);
module.exports = Question;