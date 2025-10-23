// Novel architectural approach to calculate even parity using a hierarchical bit-slicing method
module TopModule(
    input  wire [7:0] in,  // 8-bit input byte
    output reg parity    // 1-bit output for even parity
);

// Calculate parity for each 2-bit group
wire group1_parity, group2_parity, group3_parity, group4_parity;

// Group 1: Bits 7 and 6
assign group1_parity = in[7] ^ in[6];

// Group 2: Bits 5 and 4
assign group2_parity = in[5] ^ in[4];

// Group 3: Bits 3 and 2
assign group3_parity = in[3] ^ in[2];

// Group 4: Bits 1 and 0
assign group4_parity = in[1] ^ in[0];

// Final parity calculation by XORing group parities
always @(*) begin
    parity = group1_parity ^ group2_parity ^ group3_parity ^ group4_parity;
end

endmodule