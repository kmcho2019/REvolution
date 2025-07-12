module TopModule (
    input  a,    // First input operand
    input  b,    // Second input operand
    output q     // Output (logical AND of inputs)
);
    // Continuous assignment for optimal combinational logic
    assign q = a & b;
endmodule