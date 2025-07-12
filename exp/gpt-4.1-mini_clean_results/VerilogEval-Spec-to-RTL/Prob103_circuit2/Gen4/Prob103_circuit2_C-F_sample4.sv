module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire x1, x2;

assign x1 = a ^~ b;  // XNOR of a and b
assign x2 = c ^~ d;  // XNOR of c and d
assign q  = x1 ^~ x2; // XNOR of x1 and x2

endmodule