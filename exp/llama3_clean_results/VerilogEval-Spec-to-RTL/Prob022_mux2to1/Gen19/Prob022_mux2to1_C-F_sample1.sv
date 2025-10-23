// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a to be selected when sel is 0
    input  b,  // Input b to be selected when sel is 1
    input  sel, // Select input that determines whether a or b is passed to out
    output out  // Output of the multiplexer
);

// Implement the multiplexer using the ternary operator for efficiency and readability
assign out = (sel) ? b : a; // When sel is 1, out = b; when sel is 0, out = a

endmodule