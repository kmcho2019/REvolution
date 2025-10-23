module TopModule(
    input  a,
    input  b,
    output out
);
// To optimize for high-speed implementations, consider using synthesis options
// that favor high-speed library cells or technology nodes.
// For low-power optimization, explore synthesis options or technology libraries
// that favor low-power implementations.
assign out = a & b;

endmodule