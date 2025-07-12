module TopModule(
    input  [7:0] in,
    output       parity
);

assign parity = ^in;  // The ^ operator is used for bitwise XOR reduction in Verilog

endmodule