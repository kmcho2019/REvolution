module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Using a ternary operator for simplicity and efficiency
assign out = sel ? b : a;

endmodule