module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Directly assign the output using the ternary operator for simplicity and efficiency
assign out = sel ? b : a;
endmodule