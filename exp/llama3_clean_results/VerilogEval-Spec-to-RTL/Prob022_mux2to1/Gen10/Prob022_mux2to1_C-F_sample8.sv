module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Use the ternary operator for direct and efficient implementation of the multiplexer
assign out = sel ? b : a;
endmodule