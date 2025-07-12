module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care
    output out
);

wire sel0, sel1, sel2, sel3;

// From Karnaugh map rows for cd:
// For ab=00 (a=0,b=0): row cd=00(0),01(0),11(1),10(1) → out= c | d; since d don't care, use c
// For ab=01 (a=0,b=1): row cd=00(1),01(d),11(1),10(1) → out=1 except 01=d (don't care), so output 1
// For ab=10 (a=1,b=0): row cd=00(1),01(d),11(1),10(1) → output 1
// For ab=11 (a=1,b=1): row cd=00(1),01(d),11(1),10(1) → output 1

// Define outputs for each ab combination
assign sel0 = c;              // ab=00
assign sel1 = 1'b1;           // ab=01
assign sel2 = 1'b1;           // ab=10
assign sel3 = 1'b1;           // ab=11

// Select output based on {a,b}
assign out = ( ~a & ~b & sel0 ) |
             ( ~a &  b & sel1 ) |
             (  a & ~b & sel2 ) |
             (  a &  b & sel3 );

endmodule