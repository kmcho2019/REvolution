module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

// Function f implements the truth table:
// f = (~x3 & x2) | (x3 & x1)
// Equivalently, a 2-to-1 mux controlled by x3 selecting between x2 and x1.
//
// Truth table summary:
// When x3=0, f = x2
// When x3=1, f = x1

assign f = x3 ? x1 : x2;

endmodule