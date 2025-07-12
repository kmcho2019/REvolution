module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Bitmask representing the truth table outputs (LSB first)
    // Index: 000 001 010 011 100 101 110 111
    parameter TRUTH_TABLE = 8'b1101_0010;
    
    assign f = TRUTH_TABLE[{x3, x2, x1}];
endmodule