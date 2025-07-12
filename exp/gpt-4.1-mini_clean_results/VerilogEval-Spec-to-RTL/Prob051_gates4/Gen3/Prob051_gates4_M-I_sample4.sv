module TopModule(
    input  [3:0] in,
    output wire  out_and,
    output wire  out_or,
    output wire  out_xor
);
    // Combinational logic using reduction operators for efficient gate usage
    assign out_and = &in; // Reduction AND of 4 inputs
    assign out_or  = |in; // Reduction OR of 4 inputs
    assign out_xor = ^in; // Reduction XOR of 4 inputs
endmodule