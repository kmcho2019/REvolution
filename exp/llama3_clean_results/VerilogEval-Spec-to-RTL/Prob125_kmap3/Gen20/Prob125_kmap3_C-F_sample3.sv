module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Ignored due to don't-care condition
    output out
);

// Simplified logical expression that directly implements the Karnaugh map conditions
// The expression prioritizes 'a' being 1 for simplicity and synthesis efficiency
assign out = a || (!a && !b && c);

endmodule