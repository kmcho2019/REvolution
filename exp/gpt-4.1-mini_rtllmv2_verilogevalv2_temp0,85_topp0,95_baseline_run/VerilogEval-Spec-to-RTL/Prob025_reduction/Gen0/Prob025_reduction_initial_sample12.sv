module TopModule(
    input  [7:0] in,
    output      parity
);
    assign parity = ^in;  // The reduction XOR operator computes XOR of all bits in 'in'
endmodule