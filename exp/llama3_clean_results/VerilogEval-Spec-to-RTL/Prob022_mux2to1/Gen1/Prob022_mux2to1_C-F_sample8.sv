module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Implement a 2-to-1 multiplexer using the ternary operator
// Select input 'a' when 'sel' is 0, and input 'b' when 'sel' is 1
assign out = sel ? b : a;

endmodule