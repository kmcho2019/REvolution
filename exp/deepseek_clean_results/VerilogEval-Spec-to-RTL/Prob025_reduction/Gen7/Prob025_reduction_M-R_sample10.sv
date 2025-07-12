module TopModule (
    input [7:0] in,
    output parity
);
    // Direct XOR reduction of all input bits
    assign parity = ^in;
endmodule