module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Even parity means the number of 1s in inputs is even (0,2,4)
// We'll list the minterms for even parity:

wire m0, m1, m2, m3, m4, m5, m6;

// 0 ones: a=0,b=0,c=0,d=0
assign m0 = ~a & ~b & ~c & ~d;

// 2 ones (six combinations):
assign m1 = ~a & ~b &  c &  d; // c=1, d=1
assign m2 = ~a &  b & ~c &  d; // b=1, d=1
assign m3 = ~a &  b &  c & ~d; // b=1, c=1
assign m4 =  a & ~b & ~c &  d; // a=1, d=1
assign m5 =  a & ~b &  c & ~d; // a=1, c=1
assign m6 =  a &  b & ~c & ~d; // a=1, b=1

// 4 ones (all inputs = 1)
wire m7;
assign m7 = a & b & c & d;

// q = OR of these minterms
assign q = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7;

endmodule