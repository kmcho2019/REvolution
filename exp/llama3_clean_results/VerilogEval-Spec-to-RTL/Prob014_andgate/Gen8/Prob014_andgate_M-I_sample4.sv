module TopModule(
    input  a,
    input  b,
    output out
);
// The current implementation is already minimal and efficient.
// To potentially improve power consumption, consider synthesis options
// or library selections that favor low-power implementations.
assign out = a & b;

endmodule