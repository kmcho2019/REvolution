module TopModule (
    input  [7:0] in,
    output       parity
);

    // Direct XOR reduction on the entire 8-bit input to produce even parity
    assign parity = ^in;

endmodule