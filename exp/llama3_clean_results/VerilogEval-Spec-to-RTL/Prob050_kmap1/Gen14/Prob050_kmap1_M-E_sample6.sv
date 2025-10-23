module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Intermediate signals for the AND and OR operations
wire a_active;
wire bc_active;

// Implement the condition when 'a' is active (output is always 1)
assign a_active = a;

// Implement the condition when 'a' is inactive (output depends on 'b' or 'c')
assign bc_active = b | c;

// Final output selection using an OR gate
assign out = a_active | bc_active;

endmodule