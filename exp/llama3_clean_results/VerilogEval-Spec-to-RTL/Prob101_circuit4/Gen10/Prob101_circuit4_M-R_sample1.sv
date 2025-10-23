module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Refactored to use a conditional operator for determining q
assign q = (b || c) ? 1'b1 : 1'b0;

endmodule