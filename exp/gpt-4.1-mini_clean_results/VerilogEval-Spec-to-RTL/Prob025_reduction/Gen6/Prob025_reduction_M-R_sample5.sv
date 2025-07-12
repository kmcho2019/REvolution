module TopModule (
    input  [7:0] in,
    output       parity
);

    // Balanced XOR tree implemented directly in one assign statement
    assign parity = (^in[3:0]) ^ (^in[7:4]);

endmodule