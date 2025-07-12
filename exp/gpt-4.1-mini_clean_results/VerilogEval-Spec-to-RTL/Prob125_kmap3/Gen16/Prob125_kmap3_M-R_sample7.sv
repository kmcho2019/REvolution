module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

wire m1, m2, m3, m4, m5;

// Minterms according to Karnaugh map '1's (using variable names in order abcd = ab (columns), cd (rows))
// Mapping inputs: a,b (ab), c,d (cd)

// m1: ab=10 (a=1,b=0), cd=00 (c=0,d=0) => a & ~b & ~c & ~d 
// From K-map: for 00 row, column 10 cell = 1 
assign m1 = a & ~b & ~c;

// m2: ab=11 (a=1,b=1), cd=00 (c=0,d=0) => a & b & ~c & ~d 
// From K-map: for 00 row, column 11 cell =1
assign m2 = a & b & ~c;

// m3: ab=11 (a=1,b=1), cd=11 (c=1,d=1) => a & b & c; d is don't care so ignored
// From K-map: for 11 row, column 11 cell =1
assign m3 = a & b & c;

// m4: ab=10 (a=1,b=0), cd=11 (c=1,d=1) => a & ~b & c; d don't care
// From K-map: for 11 row, column 10 cell =1
assign m4 = a & ~b & c;

// m5: ab=00 (a=0,b=0), cd=00 (c=0,d=0) => ~a & ~b & ~c; K-map cell is 0, so skip
// Instead, for row=10 or 11 and col=01 (a=0,b=1), K-map =1, that corresponds to
// ab=01 (a=0,b=1), cd=10 (c=1,d=0) and cd=11 (c=1,d=1) both 1s
assign m5 = ~a & b & c;  // covers (01,10) and (01,11) columns and rows from K-map

// Actually, to cover all ones from K-map, the minimal minterms that cover all 1s are:
// For row 00:
// (ab=10) a & ~b & ~c (m1)
// (ab=11) a & b & ~c (m2)
// For row 10 and 11:
// all with c=1 and (ab=01,10,11) columns => c & (b | a)
// To cover this with m3, m4, m5:
wire row_high_c = c & ((a & b) | (a & ~b) | (~a & b));
assign m3 = a & b & c;
assign m4 = a & ~b & c;
assign m5 = ~a & b & c;

assign out = m1 | m2 | m3 | m4 | m5;

endmodule