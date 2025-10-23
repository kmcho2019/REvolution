module TopModule(
    input  [7:0] in,
    output       parity
);

assign parity = ^in; // The ^ operator performs a bitwise XOR reduction on the vector in

endmodule