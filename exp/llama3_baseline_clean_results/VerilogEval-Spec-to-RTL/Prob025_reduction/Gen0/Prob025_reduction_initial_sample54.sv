module TopModule(
    input  [7:0] in,
    output parity
);

assign parity = ^in; // The ^ operator is the reduction XOR operator in Verilog

endmodule