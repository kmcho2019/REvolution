module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// For out_both: bits 0..2 check in[i] & in[i+1]; bit 3 = 0 (no neighbor)
assign out_both[2:0] = in[2:0] & in[3:1];
assign out_both[3] = 1'b0;

// For out_any: bits 1..3 check in[i] | in[i-1]; bit 0 = 0 (no neighbor)
assign out_any[3:1] = in[3:1] | in[2:0];
assign out_any[0] = 1'b0;

// For out_different: each bit compares in[i] to neighbor to the left with wrap-around:
// neighbors: [3] neighbor left is in[0], and for others neighbor left is in[i+1 mod 4]
// Implement wrapping by concatenation and XOR
wire [3:0] neighbor_left = {in[0], in[3:1]};
assign out_different = in ^ neighbor_left;

endmodule