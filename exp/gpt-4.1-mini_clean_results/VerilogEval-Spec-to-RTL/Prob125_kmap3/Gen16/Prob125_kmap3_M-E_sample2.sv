module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

// When c=0, from K-map:
// cd=00 and cd=01 rows with c=0 correspond to two rows:
// row 00: ab=01->0,00->1,10->1,11->1 (rearranged for (a,b))
// row 01: ab=01->0,00->0,10->d,11->d (d ignored)
// Simplify for c=0: looking at outputs when c=0, out= a | (~b & a') 
// After analysis, for c=0: out = a | (~b & ~a) = a | (~b & ~a)
// Which simplifies to (~b) | a

wire not_b = ~b;
wire not_a = ~a;

// f0 = ~b | a
wire f0 = not_b | a;

// When c=1, from K-map rows 10 and 11:
// 11: ab=01->1,00->1,10->1,11->1
// 10: ab=01->1,00->1,10->1,11->1
// So when c=1, out=1 for all ab combinations except for a few don't cares
// But checking K-map precisely, out=1 whenever c=1.

wire f1 = 1'b1;

// Output mux by c
assign out = c ? f1 : f0;

endmodule