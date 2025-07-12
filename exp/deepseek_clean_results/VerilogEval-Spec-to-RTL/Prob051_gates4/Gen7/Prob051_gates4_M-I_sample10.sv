module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;    // Optimal 4-input AND
    assign out_or  = |in;    // Optimal 4-input OR
    assign out_xor = ^in;    // Optimal 4-input XOR

endmodule