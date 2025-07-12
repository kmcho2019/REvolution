// Top-level module computing the outputs directly
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in;  // Reduction AND operation
    assign out_or  = |in;  // Reduction OR operation
    assign out_xor = ^in;  // Reduction XOR operation
endmodule