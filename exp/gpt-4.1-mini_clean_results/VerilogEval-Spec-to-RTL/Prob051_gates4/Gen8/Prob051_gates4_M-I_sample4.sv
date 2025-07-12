module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Directly apply reduction operators on the 4-bit input
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule