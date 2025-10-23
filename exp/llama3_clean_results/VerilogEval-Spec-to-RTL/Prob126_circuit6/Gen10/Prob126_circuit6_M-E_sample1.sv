module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Use bitwise operations to generate the output
assign q = {
    (a[2] ? 1 : 0),  // Bit 15
    (a[1] ? 1 : 0),  // Bit 14
    (a[0] ? 1 : 0),  // Bit 13
    1'b0,          // Bit 12
    (a[2] ? 1 : 0),  // Bit 11
    (a[1] ? 1 : 0),  // Bit 10
    (a[0] ? 1 : 0),  // Bit 9
    1'b0,          // Bit 8
    (a[2] ? 1 : 0),  // Bit 7
    (a[1] ? 1 : 0),  // Bit 6
    (a[0] ? 1 : 0),  // Bit 5
    1'b0,          // Bit 4
    (a[2] ? 1 : 0),  // Bit 3
    (a[1] ? 1 : 0),  // Bit 2
    (a[0] ? 1 : 0),  // Bit 1
    1'b0           // Bit 0
};

// Alternatively, we can use arithmetic operations to generate the output
// assign q = (a * 16'h1232) + (a * 16'haee0) + (a * 16'h27d4) + (a * 16'h5a0e) + (a * 16'h2066) + (a * 16'h64ce) + (a * 16'hc526) + (a * 16'h2f19);

endmodule