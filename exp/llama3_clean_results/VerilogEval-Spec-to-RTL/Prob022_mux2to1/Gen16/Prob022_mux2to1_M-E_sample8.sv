// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Internal wire for the inverse of sel
wire not_sel;

// Invert the select signal
not not_sel_inv(sel, not_sel);

// Use AND gates to conditionally pass through inputs based on sel and its inverse
wire cond_a, cond_b;
and cond_a_and(a, not_sel, cond_a);
and cond_b_and(b, sel, cond_b);

// Use an OR gate to combine the conditional outputs
or out_or(cond_a, cond_b, out);

endmodule