module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Segment the LFSR into 4 parts (8 bits each)
wire [7:0] seg3 = q[31:24];
wire [7:0] seg2 = q[23:16];
wire [7:0] seg1 = q[15:8];
wire [7:0] seg0 = q[7:0];

// Local feedback computation for each segment
wire seg3_fb = seg3[7] ^ q[0];  // Bit 31 (32)
wire seg2_fb = seg2[7] ^ q[0];  // Bit 23 (24)
wire seg1_fb = seg1[7];          // No tap
wire seg0_fb = seg0[1] ^ seg0[0] ^ q[0];  // Bits 1 and 0 (2 and 1)

// Next state computation for each segment
wire [7:0] next_seg3 = {seg3_fb, seg3[7:1]};
wire [7:0] next_seg2 = {seg2_fb, seg2[7:1]};
wire [7:0] next_seg1 = {seg1_fb, seg1[7:1]};
wire [7:0] next_seg0 = {seg0_fb, seg0[7:1]};

// Combined next state
wire [31:0] next_q = reset ? 32'h1 : {next_seg3, next_seg2, next_seg1, next_seg0};

always @(posedge clk) begin
    q <= next_q;
end

endmodule