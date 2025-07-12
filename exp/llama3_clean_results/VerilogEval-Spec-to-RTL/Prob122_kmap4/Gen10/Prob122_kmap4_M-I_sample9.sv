module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The existing solution is already optimized for area and power.
// To maintain simplicity and efficiency, we keep the same logic.
assign out = (a ^ b) ^ (c ^ d);

endmodule