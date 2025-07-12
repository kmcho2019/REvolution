module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly use built-in reduction XOR operator to compute even parity
    assign parity = ^in;
endmodule