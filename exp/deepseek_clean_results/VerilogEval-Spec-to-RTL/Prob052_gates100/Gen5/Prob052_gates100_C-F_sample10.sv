module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 100-input AND using reduction operator (optimal implementation)
    assign out_and = &in;

    // 100-input OR using reduction operator (optimal implementation)
    assign out_or = |in;

    // 100-input XOR using reduction operator (optimal implementation)
    assign out_xor = ^in;

endmodule