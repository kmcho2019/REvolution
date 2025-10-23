module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct implementation of in1 AND (NOT in2)
    // Combines inversion and AND in one expression
    // for optimal PPA while maintaining clarity
    assign out = in1 & ~in2;
endmodule