// Module declaration for a 2-to-1 multiplexer using a ternary operator with assign
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement a 2-to-1 multiplexer using a ternary operator with assign
assign out = (sel) ? b : a;

endmodule