module TopModule(
    input  x3,
    input  x2,
    input  x1,
    output f
);

// Implements function f based on truth table:
// f = (~x3 & x2) | (x3 & x1)
// Equivalent to 2-to-1 mux: if x3=0, f = x2; else f = x1
assign f = x3 ? x1 : x2;

endmodule