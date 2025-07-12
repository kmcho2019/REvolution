module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The existing solution is already quite efficient. However, to ensure optimal synthesis,
// we can maintain the same logic but consider alternative expressions that might be
// optimized differently by synthesis tools. In this case, the XOR operation is already
// the most efficient way to implement the required logic, so we keep it as is.

assign out = (a ^ b) ^ (c ^ d);

endmodule