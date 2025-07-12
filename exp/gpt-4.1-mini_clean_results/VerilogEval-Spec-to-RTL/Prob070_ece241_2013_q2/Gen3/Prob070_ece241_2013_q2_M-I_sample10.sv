module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Minimal sum-of-products for outputs 1 at 2(0010),7(0111),15(1111)
wire term_2  = na & nb & c & nd;    // 2 = 0 0 1 0
wire term_7  = na & b & c & d;      // 7 = 0 1 1 1
wire term_15 = a & b & c & d;       // 15= 1 1 1 1

assign out_sop = term_2 | term_7 | term_15;

// Minimal product-of-sums covering zeros (0,1,4,5,6,9,10,13,14)
wire clause1 = a | b | d;            // covers some zeros
wire clause2 = a | c | d;            // covers some zeros
wire clause3 = na | nb | c | nd;     // covers some zeros

assign out_pos = clause1 & clause2 & clause3;

endmodule