module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement the multiplexer using a ternary operator
assign out = sel ? b : a;
endmodule