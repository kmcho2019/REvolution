module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Direct assignment using Verilog reduction operators
    assign out_and = &in;  // Reduction AND of all 4 bits
    assign out_or  = |in;  // Reduction OR of all 4 bits
    assign out_xor = ^in;  // Reduction XOR of all 4 bits
endmodule