module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &(in[3:0]);  // Reduction AND operation
    assign out_or = |(in[3:0]);   // Reduction OR operation
    assign out_xor = ^(in[3:0]);  // Reduction XOR operation
endmodule