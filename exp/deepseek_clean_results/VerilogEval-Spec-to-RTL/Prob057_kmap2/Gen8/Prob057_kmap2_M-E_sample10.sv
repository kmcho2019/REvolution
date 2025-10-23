module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Prime implicants from K-map analysis
wire term1 = ~a & ~d;        // ~a & ~d
wire term2 = ~b & ~c;        // ~b & ~c
wire term3 = b & c;           // b & c
wire term4 = a & ~b & d;     // a & ~b & d

// Final output is OR of all terms
assign out = term1 | term2 | term3 | term4;

endmodule