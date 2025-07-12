module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care
    output out
);

// The logic is already simplified based on the given Karnaugh map.
// To potentially improve PPA, we ensure the expression is in a form that synthesis tools can optimize.
assign out = a || (!a && !b && c);

endmodule