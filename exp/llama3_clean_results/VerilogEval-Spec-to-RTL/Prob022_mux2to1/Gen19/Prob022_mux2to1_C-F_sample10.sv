// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement the multiplexer using the ternary operator for efficiency and readability
// The ternary operator selects input 'b' when 'sel' is 1, otherwise it selects input 'a'
assign out = (sel) ? b : a;

endmodule