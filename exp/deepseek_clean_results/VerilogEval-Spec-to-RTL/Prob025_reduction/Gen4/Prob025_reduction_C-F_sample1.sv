module TopModule (
    input [7:0] in,
    output parity
);
    // Even parity is the XOR of all input bits
    // This creates a 1 if there's an odd number of 1s in 'in'
    // making the total count (including parity) always even
    assign parity = ^in;
endmodule