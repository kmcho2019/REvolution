module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

// Explicitly using a single OR gate
assign out = a || b || c;

// Alternatively, considering direct implementation
// assign out = (a || b) || c; // This might not provide significant improvement over the current simple OR

endmodule