module TopModule(
    input  a,
    input  b,
    output out
);

// Using combinational logic to reduce power consumption
// The XOR operation (^) is performed first, then its result is inverted (~) to implement XNOR
// This approach is efficient and easy to understand, making it suitable for a wide range of applications
assign out = ~(a ^ b);

endmodule