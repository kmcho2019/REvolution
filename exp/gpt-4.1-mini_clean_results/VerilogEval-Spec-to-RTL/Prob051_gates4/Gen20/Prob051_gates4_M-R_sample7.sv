module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use Verilog reduction operators to implement the 4-input gates directly
    assign out_and = &in;  // Reduction AND
    assign out_or  = |in;  // Reduction OR
    assign out_xor = ^in;  // Reduction XOR (parity)

endmodule