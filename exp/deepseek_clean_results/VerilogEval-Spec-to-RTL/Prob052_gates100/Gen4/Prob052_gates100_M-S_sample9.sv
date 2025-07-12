module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // 100-input AND using reduction operator
    assign out_or = |in;   // 100-input OR using reduction operator
    assign out_xor = ^in;  // 100-input XOR using reduction operator

endmodule