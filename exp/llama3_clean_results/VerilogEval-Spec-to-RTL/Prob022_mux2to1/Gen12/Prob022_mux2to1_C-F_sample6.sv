// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement a 2-to-1 multiplexer using the ternary operator
// The output 'out' is assigned the value of 'b' when 'sel' is 1, and 'a' when 'sel' is 0
assign out = sel? b : a;

endmodule