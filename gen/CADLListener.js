// Generated from CADL.g4 by ANTLR 4.5.1
// jshint ignore: start
var antlr4 = require('antlr4/index');

// This class defines a complete listener for a parse tree produced by CADLParser.
function CADLListener() {
	antlr4.tree.ParseTreeListener.call(this);
	return this;
}

CADLListener.prototype = Object.create(antlr4.tree.ParseTreeListener.prototype);
CADLListener.prototype.constructor = CADLListener;

// Enter a parse tree produced by CADLParser#program.
CADLListener.prototype.enterProgram = function(ctx) {
};

// Exit a parse tree produced by CADLParser#program.
CADLListener.prototype.exitProgram = function(ctx) {
};


// Enter a parse tree produced by CADLParser#comments.
CADLListener.prototype.enterComments = function(ctx) {
};

// Exit a parse tree produced by CADLParser#comments.
CADLListener.prototype.exitComments = function(ctx) {
};


// Enter a parse tree produced by CADLParser#evaluation.
CADLListener.prototype.enterEvaluation = function(ctx) {
};

// Exit a parse tree produced by CADLParser#evaluation.
CADLListener.prototype.exitEvaluation = function(ctx) {
};


// Enter a parse tree produced by CADLParser#definition.
CADLListener.prototype.enterDefinition = function(ctx) {
};

// Exit a parse tree produced by CADLParser#definition.
CADLListener.prototype.exitDefinition = function(ctx) {
};


// Enter a parse tree produced by CADLParser#svar_def.
CADLListener.prototype.enterSvar_def = function(ctx) {
};

// Exit a parse tree produced by CADLParser#svar_def.
CADLListener.prototype.exitSvar_def = function(ctx) {
};


// Enter a parse tree produced by CADLParser#svar_expr.
CADLListener.prototype.enterSvar_expr = function(ctx) {
};

// Exit a parse tree produced by CADLParser#svar_expr.
CADLListener.prototype.exitSvar_expr = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_def.
CADLListener.prototype.enterMvar_def = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_def.
CADLListener.prototype.exitMvar_def = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_set.
CADLListener.prototype.enterMvar_set = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_set.
CADLListener.prototype.exitMvar_set = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_dimension.
CADLListener.prototype.enterMvar_dimension = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_dimension.
CADLListener.prototype.exitMvar_dimension = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_item_single.
CADLListener.prototype.enterMvar_item_single = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_item_single.
CADLListener.prototype.exitMvar_item_single = function(ctx) {
};


// Enter a parse tree produced by CADLParser#var_expr.
CADLListener.prototype.enterVar_expr = function(ctx) {
};

// Exit a parse tree produced by CADLParser#var_expr.
CADLListener.prototype.exitVar_expr = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_func_ref.
CADLListener.prototype.enterMvar_func_ref = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_func_ref.
CADLListener.prototype.exitMvar_func_ref = function(ctx) {
};


// Enter a parse tree produced by CADLParser#svar_func_ref.
CADLListener.prototype.enterSvar_func_ref = function(ctx) {
};

// Exit a parse tree produced by CADLParser#svar_func_ref.
CADLListener.prototype.exitSvar_func_ref = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_item_block.
CADLListener.prototype.enterMvar_item_block = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_item_block.
CADLListener.prototype.exitMvar_item_block = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_item_list.
CADLListener.prototype.enterMvar_item_list = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_item_list.
CADLListener.prototype.exitMvar_item_list = function(ctx) {
};


// Enter a parse tree produced by CADLParser#svar_list.
CADLListener.prototype.enterSvar_list = function(ctx) {
};

// Exit a parse tree produced by CADLParser#svar_list.
CADLListener.prototype.exitSvar_list = function(ctx) {
};


// Enter a parse tree produced by CADLParser#mvar_expr.
CADLListener.prototype.enterMvar_expr = function(ctx) {
};

// Exit a parse tree produced by CADLParser#mvar_expr.
CADLListener.prototype.exitMvar_expr = function(ctx) {
};


// Enter a parse tree produced by CADLParser#block_stmt.
CADLListener.prototype.enterBlock_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#block_stmt.
CADLListener.prototype.exitBlock_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#stmt.
CADLListener.prototype.enterStmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#stmt.
CADLListener.prototype.exitStmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#ctrl_stmt.
CADLListener.prototype.enterCtrl_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#ctrl_stmt.
CADLListener.prototype.exitCtrl_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#output_stmt.
CADLListener.prototype.enterOutput_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#output_stmt.
CADLListener.prototype.exitOutput_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#print_stmt.
CADLListener.prototype.enterPrint_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#print_stmt.
CADLListener.prototype.exitPrint_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#if_stmt.
CADLListener.prototype.enterIf_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#if_stmt.
CADLListener.prototype.exitIf_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#loop_stmt.
CADLListener.prototype.enterLoop_stmt = function(ctx) {
};

// Exit a parse tree produced by CADLParser#loop_stmt.
CADLListener.prototype.exitLoop_stmt = function(ctx) {
};


// Enter a parse tree produced by CADLParser#func_def.
CADLListener.prototype.enterFunc_def = function(ctx) {
};

// Exit a parse tree produced by CADLParser#func_def.
CADLListener.prototype.exitFunc_def = function(ctx) {
};


// Enter a parse tree produced by CADLParser#var_item_range.
CADLListener.prototype.enterVar_item_range = function(ctx) {
};

// Exit a parse tree produced by CADLParser#var_item_range.
CADLListener.prototype.exitVar_item_range = function(ctx) {
};


// Enter a parse tree produced by CADLParser#var_item_fromto.
CADLListener.prototype.enterVar_item_fromto = function(ctx) {
};

// Exit a parse tree produced by CADLParser#var_item_fromto.
CADLListener.prototype.exitVar_item_fromto = function(ctx) {
};


// Enter a parse tree produced by CADLParser#constant.
CADLListener.prototype.enterConstant = function(ctx) {
};

// Exit a parse tree produced by CADLParser#constant.
CADLListener.prototype.exitConstant = function(ctx) {
};



exports.CADLListener = CADLListener;