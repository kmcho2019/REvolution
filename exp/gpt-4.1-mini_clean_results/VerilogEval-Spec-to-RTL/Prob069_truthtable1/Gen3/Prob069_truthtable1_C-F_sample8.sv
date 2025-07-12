module TopModule(
    input  x3,
    input  x2,
    input  x1,
    output f
);

// Function f implements the truth table as:
// f = (~x3 & x2) | (x3 & x1)
// which is equivalent to:
// if x3 == 0 then f = x2
// else f = x1
// This corresponds to a 2-to-1 multiplexer controlled by x3.
assign f = x3 ? x1 : x2;

endmodule