module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate terms
wire term1 = d & (~a & ~b & c | b & ~c);
wire term2 = a & (b & ~(c & d) | c & ~d);

// Final output
assign out = ~(term1 | term2);

endmodule