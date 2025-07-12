module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire [99:0] rotated;
reg [6:0] rot_amount;
wire right_rotate = (ena == 2'b01);
wire left_rotate = (ena == 2'b10);

// Priority encoder for rotation amount
always @(*) begin
    if (right_rotate) rot_amount = 7'd1;
    else if (left_rotate) rot_amount = 7'd99; // Left rotate by 1 = right rotate by 99
    else rot_amount = 7'd0;
end

// 7-stage logarithmic barrel rotator
wire [99:0] stage0 = (rot_amount[0]) ? {q[0], q[99:1]} : q;
wire [99:0] stage1 = (rot_amount[1]) ? {stage0[1:0], stage0[99:2]} : stage0;
wire [99:0] stage2 = (rot_amount[2]) ? {stage1[3:0], stage1[99:4]} : stage1;
wire [99:0] stage3 = (rot_amount[3]) ? {stage2[7:0], stage2[99:8]} : stage2;
wire [99:0] stage4 = (rot_amount[4]) ? {stage3[15:0], stage3[99:16]} : stage3;
wire [99:0] stage5 = (rot_amount[5]) ? {stage4[31:0], stage4[99:32]} : stage4;
wire [99:0] stage6 = (rot_amount[6]) ? {stage5[63:0], stage5[99:64]} : stage5;

assign rotated = stage6;

always @(posedge clk) begin
    if (load) q <= data;
    else if (|ena) q <= rotated;
end

endmodule