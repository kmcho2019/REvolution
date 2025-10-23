// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Internal signals
wire a_selected;
wire b_selected;

// Generate signals for selected inputs
assign a_selected = ~sel & a;
assign b_selected = sel & b;

// Implement a 2-to-1 multiplexer using logical OR
assign out = a_selected | b_selected;

endmodule