module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Simplified logic focusing on essential conditions
assign out = a || (!a &&!b && c);

// Alternatively, considering the suggestion for bitwise operations
// assign out = a | (!a & ~b & c);

endmodule