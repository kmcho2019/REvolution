// Module declaration for an improved 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement a 2-to-1 multiplexer using basic logic gates for potential synthesis optimization.
wire sel_bar; // Inverted select signal

// Invert the select signal
assign sel_bar = ~sel;

// Use AND-OR logic to implement the multiplexer
assign out = (sel_bar & a) | (sel & b);

endmodule