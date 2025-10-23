module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// XOR-based implementation with selective masking
wire xor_ab, xor_cd, base_pattern;
wire correction1, correction2;

assign xor_ab = a ^ b;
assign xor_cd = c ^ d;
assign base_pattern = xor_ab ^ xor_cd;

// Corrections for specific positions
assign correction1 = ~a & ~b & ~c;    // Fixes top-left corner
assign correction2 = a & b & ~d;      // Fixes bottom-right corner

assign out = base_pattern | correction1 | correction2;

endmodule