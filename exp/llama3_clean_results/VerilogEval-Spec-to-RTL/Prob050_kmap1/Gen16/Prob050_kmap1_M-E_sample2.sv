module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Intermediate signal to represent (b | c)
wire bc_or;

// Assign bc_or as the OR of b and c
assign bc_or = b | c;

// Final output is the OR of a and bc_or
assign out = a | bc_or;

endmodule