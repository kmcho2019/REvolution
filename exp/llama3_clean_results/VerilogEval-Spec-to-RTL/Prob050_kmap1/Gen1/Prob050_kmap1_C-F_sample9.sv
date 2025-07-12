// TopModule implements the logic described by the given Karnaugh map.
// The simplified Boolean expression is out = a + b + c, which is
// implemented here for its efficiency and simplicity.

module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    output out // Output signal out
);

// Assign the output 'out' based on the simplified Boolean expression.
assign out = a | b | c;

endmodule