module TopModule(
    input  a,
    input  b,
    output out
);

// Using combinational logic to reduce power consumption
// The XOR operation (^) is performed first, then its result is inverted (~) to implement XNOR
assign out = ~(a ^ b);

endmodule