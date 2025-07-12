// Refactored version of the TopModule using a ternary operator for the AND operation
module TopModule(
    input  a,
    input  b,
    output q
);

assign q = (a == 1) && (b == 1) ? 1 : 0;

endmodule