module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Shared intermediate terms
wire ab = a & b;
wire cd = c & d;
wire nc = ~c;
wire nd = ~d;

// Optimized terms
wire term1 = ~a & ~b & cd;
wire term2 = ab & (nc | nd);
wire term3 = (b & nc & d) | (a & c & nd);

// Final NAND implementation (equivalent to original NOR)
assign out = ~(term1 | term2 | term3);

endmodule