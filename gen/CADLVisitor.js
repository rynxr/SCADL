// Generated from CADL.g4 by ANTLR 4.5.1
// jshint ignore: start
var antlr4 = require('antlr4/index');

  String.prototype.times = function(n) { return (n > 0) ? Array.prototype.join.call({length:n+1}, this) : ""; };


// This class defines a complete generic visitor for a parse tree produced by CADLParser.

function CADLVisitor() {
	antlr4.tree.ParseTreeVisitor.call(this);
	return this;
}

CADLVisitor.prototype = Object.create(antlr4.tree.ParseTreeVisitor.prototype);
CADLVisitor.prototype.constructor = CADLVisitor;

// Visit a parse tree produced by CADLParser#program.
CADLVisitor.prototype.visitProgram = function(ctx) {
};


// Visit a parse tree produced by CADLParser#comments.
CADLVisitor.prototype.visitComments = function(ctx) {
};


// Visit a parse tree produced by CADLParser#evaluation.
CADLVisitor.prototype.visitEvaluation = function(ctx) {
};


// Visit a parse tree produced by CADLParser#definition.
CADLVisitor.prototype.visitDefinition = function(ctx) {
};


// Visit a parse tree produced by CADLParser#svar_def.
CADLVisitor.prototype.visitSvar_def = function(ctx) {
};


// Visit a parse tree produced by CADLParser#svar_expr.
CADLVisitor.prototype.visitSvar_expr = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_def.
CADLVisitor.prototype.visitMvar_def = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_set.
CADLVisitor.prototype.visitMvar_set = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_dimension.
CADLVisitor.prototype.visitMvar_dimension = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_item_single.
CADLVisitor.prototype.visitMvar_item_single = function(ctx) {
};


// Visit a parse tree produced by CADLParser#var_expr.
CADLVisitor.prototype.visitVar_expr = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_func_ref.
CADLVisitor.prototype.visitMvar_func_ref = function(ctx) {
};


// Visit a parse tree produced by CADLParser#svar_func_ref.
CADLVisitor.prototype.visitSvar_func_ref = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_item_block.
CADLVisitor.prototype.visitMvar_item_block = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_item_list.
CADLVisitor.prototype.visitMvar_item_list = function(ctx) {
};


// Visit a parse tree produced by CADLParser#svar_list.
CADLVisitor.prototype.visitSvar_list = function(ctx) {
};


// Visit a parse tree produced by CADLParser#mvar_expr.
CADLVisitor.prototype.visitMvar_expr = function(ctx) {
};


// Visit a parse tree produced by CADLParser#block_stmt.
CADLVisitor.prototype.visitBlock_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#stmt.
CADLVisitor.prototype.visitStmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#ctrl_stmt.
CADLVisitor.prototype.visitCtrl_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#output_stmt.
CADLVisitor.prototype.visitOutput_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#print_stmt.
CADLVisitor.prototype.visitPrint_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#if_stmt.
CADLVisitor.prototype.visitIf_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#loop_stmt.
CADLVisitor.prototype.visitLoop_stmt = function(ctx) {
};


// Visit a parse tree produced by CADLParser#func_def.
CADLVisitor.prototype.visitFunc_def = function(ctx) {
};


// Visit a parse tree produced by CADLParser#var_item_range.
CADLVisitor.prototype.visitVar_item_range = function(ctx) {
};


// Visit a parse tree produced by CADLParser#var_item_fromto.
CADLVisitor.prototype.visitVar_item_fromto = function(ctx) {
};


// Visit a parse tree produced by CADLParser#constant.
CADLVisitor.prototype.visitConstant = function(ctx) {
};



exports.CADLVisitor = CADLVisitor;