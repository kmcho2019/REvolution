module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for better readability
wire term1 = ~a & ~b & c & d;
wire term2 = b & (~c | (a & ~d));
wire term3 = a & c & ~d;

// Final output
assign out = ~(term1 | term2 | term3);

endmodule