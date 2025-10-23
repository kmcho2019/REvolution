module TopModule (
    output zero
);
    // Optimal implementation - direct constant assignment with parameter
    parameter CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule