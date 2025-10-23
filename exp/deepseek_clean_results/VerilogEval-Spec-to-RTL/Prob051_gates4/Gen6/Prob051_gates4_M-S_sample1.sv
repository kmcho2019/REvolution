module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;    // 4-input AND using reduction operator
    assign out_or  = |in;    // 4-input OR using reduction operator
    assign out_xor = ^in;    // 4-input XOR using reduction operator

endmodule