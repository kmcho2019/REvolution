module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab_not; // (a && b)'
wire ac;    // a && c
wire bc;    // b && c
wire ab_c;  // (a || b) && c

assign ab_not = ~(a && b);
assign ac = a && c;
assign bc = b && c;
assign ab_c = (a || b) && c;

assign out = ab_not && c || ab_c || (a && b);

endmodule