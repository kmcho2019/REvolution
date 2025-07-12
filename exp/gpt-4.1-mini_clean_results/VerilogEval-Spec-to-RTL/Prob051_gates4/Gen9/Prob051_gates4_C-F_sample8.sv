module TopModule(
    input  [3:0] in,
    output       out_and,  // 4-input AND reduction
    output       out_or,   // 4-input OR reduction
    output       out_xor   // 4-input XOR reduction
);

    // Use reduction operators for clean, minimal combinational logic
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule