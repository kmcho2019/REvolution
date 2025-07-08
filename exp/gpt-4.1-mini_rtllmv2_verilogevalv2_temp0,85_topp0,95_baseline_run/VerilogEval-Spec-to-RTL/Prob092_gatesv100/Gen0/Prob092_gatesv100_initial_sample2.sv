module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// (1) out_both: out_both[i] = in[i] & in[i+1], for i=0 to 98; out_both[99] = 0
assign out_both[98:0] = in[98:0] & in[99:1];
assign out_both[99] = 1'b0;

// (2) out_any: out_any[i] = in[i] | in[i-1], for i=1 to 99; out_any[0] = 0
assign out_any[99:1] = in[99:1] | in[98:0];
assign out_any[0] = 1'b0;

// (3) out_different: out_different[i] = in[i] ^ in[(i+1)%100]
// Wrap around means out_different[99] = in[99] ^ in[0]
assign out_different = in ^ {in[0], in[99:1]};

endmodule