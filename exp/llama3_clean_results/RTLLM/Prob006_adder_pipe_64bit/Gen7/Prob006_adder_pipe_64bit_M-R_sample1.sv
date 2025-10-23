module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define pipeline stages for 64-bit addition
// Assuming 16-bit segments for simplicity
wire [15:0] seg1_sum;
wire [15:0] seg2_sum;
wire [15:0] seg3_sum;
wire [15:0] seg4_sum;
reg  [15:0] reg_seg1_sum;
reg  [15:0] reg_seg2_sum;
reg  [15:0] reg_seg3_sum;
reg  [15:0] reg_seg4_sum;

wire [15:0] seg1_carry;
wire [15:0] seg2_carry;
wire [15:0] seg3_carry;
wire [15:0] seg4_carry;

// Perform addition in segments
assign seg1_sum = adda[15:0] + addb[15:0];
assign seg2_sum = adda[31:16] + addb[31:16] + (seg1_sum[15] ? 1 : 0);
assign seg3_sum = adda[47:32] + addb[47:32] + (seg2_sum[15] ? 1 : 0);
assign seg4_sum = adda[63:48] + addb[63:48] + (seg3_sum[15] ? 1 : 0);

assign seg1_carry = (adda[15:0] + addb[15:0]) > 16'hFFFF;
assign seg2_carry = (adda[31:16] + addb[31:16]) > 16'hFFFF;
assign seg3_carry = (adda[47:32] + addb[47:32]) > 16'hFFFF;
assign seg4_carry = (adda[63:48] + addb[63:48]) > 16'hFFFF;

// Register pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_seg1_sum <= 16'd0;
        reg_seg2_sum <= 16'd0;
        reg_seg3_sum <= 16'd0;
        reg_seg4_sum <= 16'd0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        reg_seg1_sum <= seg1_sum;
        reg_seg2_sum <= seg2_sum;
        reg_seg3_sum <= seg3_sum;
        reg_seg4_sum <= seg4_sum;
        
        result <= {1'b0, reg_seg4_sum, reg_seg3_sum, reg_seg2_sum, reg_seg1_sum};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule