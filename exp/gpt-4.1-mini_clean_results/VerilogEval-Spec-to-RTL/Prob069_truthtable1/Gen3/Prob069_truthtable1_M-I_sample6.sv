module TopModule(
    input  x3,
    input  x2,
    input  x1,
    output f
);

wire f_intermediate;

// Implement function f as: f = (~x3 & x2) | (x3 & x1)
// Equivalent to a 2-to-1 mux choosing between x2 and x1 based on x3
assign f_intermediate = (~x3 & x2) | (x3 & x1);

// Assign to output
assign f = f_intermediate;

endmodule