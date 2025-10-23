// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement a 2-to-1 multiplexer using assign and ternary operator
// The ternary operator (sel ? b : a) behaves like a multiplexer, selecting 'b' when 'sel' is 1 and 'a' when 'sel' is 0.
// This is equivalent to using basic logic gates as follows: out = (a & ~sel) | (b & sel), where ~sel is the NOT of sel.
assign out = sel ? b : a;

endmodule