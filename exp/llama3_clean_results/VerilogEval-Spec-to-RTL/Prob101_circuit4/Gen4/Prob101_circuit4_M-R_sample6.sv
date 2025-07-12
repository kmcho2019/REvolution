module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Refactored to explicitly show the OR condition for b and c
assign q = b || c;

endmodule