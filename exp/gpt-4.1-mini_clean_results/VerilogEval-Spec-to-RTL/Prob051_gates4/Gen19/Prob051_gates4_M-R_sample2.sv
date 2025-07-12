module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Direct combinational assignments using reduction operators
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule