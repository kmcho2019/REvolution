module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement a 2-to-1 multiplexer using the ternary operator for conciseness and efficiency.
assign out = sel ? b : a;
endmodule