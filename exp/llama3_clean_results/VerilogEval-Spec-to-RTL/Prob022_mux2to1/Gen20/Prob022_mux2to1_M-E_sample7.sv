// Module declaration for a 2-to-1 multiplexer using logical operations
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement the multiplexer using logical operations
// The output is 'a' when 'sel' is 0, and 'b' when 'sel' is 1
// This is achieved by using AND gates with 'sel' and its inverse, and then ORing the results
assign out = (a & ~sel) | (b & sel);

endmodule