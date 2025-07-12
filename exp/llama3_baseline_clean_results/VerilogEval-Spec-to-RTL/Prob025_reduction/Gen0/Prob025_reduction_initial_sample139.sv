module TopModule(
    input  [7:0] in,
    output parity
);

assign parity = ^in;  // The ^ operator here performs an XOR reduction on all bits of 'in'

endmodule