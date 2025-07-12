module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in = {a,b,c,d}; // a=MSB, d=LSB

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Given outputs:
// 1 for inputs: 2 (0010), 7 (0111), 15 (1111)
// 0 for inputs: 0,1,4,5,6,9,10,13,14
// don't cares: 3,8,11,12

// Minimal SOP from Karnaugh map or Quine-McCluskey with don't cares:

// minterms: 2 (0010),7(0111),15(1111)
// don't cares: 3(0011),8(1000),11(1011),12(1100)

// Minimal SOP expression (covering minterms only) is:

// out_sop = (~a & b & c & d) + (a & b & c & d) + (~a & ~b & c & ~d)
// That is the same as before but confirmed correct.

// For POS minimal expression, from K-map analysis with don't-cares:
// out_pos = (a + b + d) (a + c + d) ( ~a + ~b + c + ~d )

// Let's implement these.

wire term_2  = na & nb &  c & nd;   // 2 = 0010
wire term_7  = na &  b &  c &  d;   // 7 = 0111
wire term_15 =  a &  b &  c &  d;   // 15= 1111

assign out_sop = term_2 | term_7 | term_15;

// POS clauses for zeros (0,1,4,5,6,9,10,13,14)
wire clause1 = a | b | d;
wire clause2 = a | c | d;
wire clause3 = na | nb | c | nd;

assign out_pos = clause1 & clause2 & clause3;

endmodule