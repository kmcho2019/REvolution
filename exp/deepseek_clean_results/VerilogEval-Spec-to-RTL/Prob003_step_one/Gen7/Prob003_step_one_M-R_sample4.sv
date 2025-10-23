// Refactored version using parameter
module TopModule(output one);
    parameter CONST_ONE = 1;
    assign one = CONST_ONE;
endmodule

// Alternative refactored version
/*
module TopModule(output one);
    assign one = 1'b1;  // Explicitly showing the 1-bit constant
endmodule
*/