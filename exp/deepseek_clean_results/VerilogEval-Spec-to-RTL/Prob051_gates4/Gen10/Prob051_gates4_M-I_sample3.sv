module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // 4-input AND using reduction operator
    assign out_and = &in;

    // 4-input OR using reduction operator
    assign out_or = |in;

    // 4-input XOR using reduction operator
    assign out_xor = ^in;

endmodule