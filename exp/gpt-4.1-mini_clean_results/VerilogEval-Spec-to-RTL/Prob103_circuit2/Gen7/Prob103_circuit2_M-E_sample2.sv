module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire w1, w2;

assign w1 = ~(a ^ b);  // XNOR of a and b
assign w2 = ~(c ^ d);  // XNOR of c and d
assign q  = ~(w1 ^ w2); // XNOR of w1 and w2, resulting in even parity

endmodule