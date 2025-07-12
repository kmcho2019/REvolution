module TopModule(
    input [7:0] in,
    output parity
);

assign parity = ^in; // The ^ operator in Verilog performs a bitwise XOR operation on all bits of the vector.

endmodule