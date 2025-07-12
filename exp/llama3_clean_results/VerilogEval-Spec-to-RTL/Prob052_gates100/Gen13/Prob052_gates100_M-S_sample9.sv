module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &(in[99:0]);  // bitwise AND reduction operator
    assign out_or = |(in[99:0]);   // bitwise OR reduction operator
    assign out_xor = ^(in[99:0]);  // bitwise XOR reduction operator

endmodule