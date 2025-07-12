module TopModule (
    input  [7:0] in,
    output       parity
);
    // Use the built-in XOR reduction operator for even parity calculation
    assign parity = ^in;

endmodule