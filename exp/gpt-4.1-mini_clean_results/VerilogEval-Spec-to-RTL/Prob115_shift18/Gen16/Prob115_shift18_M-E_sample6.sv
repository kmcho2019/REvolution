module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire dir_left = (amount[1] == 1'b0);
    wire dir_right = (amount[1] == 1'b1);

    // Stage 1: Shift by 8 bits or no shift depending on amount[0]
    // For left direction:
    wire [63:0] left_shift_8  = {q[55:0], 8'b0};
    wire [63:0] left_stage1 = (amount[0]) ? left_shift_8 : q;

    // For right direction (arithmetic):
    wire msb = q[63];
    wire [63:0] right_shift_8 = {{8{msb}}, q[63:8]};
    wire [63:0] right_stage1 = (amount[0]) ? right_shift_8 : q;

    // Choose intermediate after stage 1 by direction
    wire [63:0] stage1 = dir_left ? left_stage1 : right_stage1;

    // Stage 2: Shift by 1 bit or no shift depending on amount[0] inverted
    // We only shift by 1 bit if amount[0] == 0 (because 1-bit shift is encoded as amount[0]==0)
    // So stage2 shift enable is !amount[0], else no shift.

    wire stage2_shift_en = !amount[0];

    // For left direction:
    wire [63:0] left_shift_1 = {stage1[62:0], 1'b0};
    wire [63:0] left_stage2 = stage2_shift_en ? left_shift_1 : stage1;

    // For right direction:
    wire stage1_msb = stage1[63];
    wire [63:0] right_shift_1 = {stage1_msb, stage1[63:1]};
    wire [63:0] right_stage2 = stage2_shift_en ? right_shift_1 : stage1;

    // Final selected shifted value
    wire [63:0] shifted = dir_left ? left_stage2 : right_stage2;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule