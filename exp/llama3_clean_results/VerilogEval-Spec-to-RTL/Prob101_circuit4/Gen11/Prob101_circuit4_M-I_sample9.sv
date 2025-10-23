module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Maintaining the simple and direct OR condition for b and c
assign q = b || c;

endmodule