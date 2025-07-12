module TopModule (
    input  [7:0] in,
    output       parity
);
    // Even parity is the XOR of all bits in 'in'
    assign parity = ^in;
endmodule