module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Divide the 8-bit input into four 2-bit segments
wire segment1_parity = in[1] ^ in[0];
wire segment2_parity = in[3] ^ in[2];
wire segment3_parity = in[5] ^ in[4];
wire segment4_parity = in[7] ^ in[6];

// Calculate the overall parity by XORing the segment parities
always @(*) begin
    parity = segment1_parity ^ segment2_parity ^ segment3_parity ^ segment4_parity;
end

endmodule