module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement a 2-to-1 multiplexer using the ternary operator for conciseness and efficiency.
// This design is chosen for its simplicity, which is beneficial for area efficiency and potentially low power consumption.
assign out = sel ? b : a;
endmodule