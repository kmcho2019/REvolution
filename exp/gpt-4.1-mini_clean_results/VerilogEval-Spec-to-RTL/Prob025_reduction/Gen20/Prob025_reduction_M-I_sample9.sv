module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR reduction of all 8 input bits
    assign parity = ^in;
endmodule