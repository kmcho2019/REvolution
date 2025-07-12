module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: shift by 1 bit
    wire [63:0] stage1_left  = {q[62:0], 1'b0};
    wire [63:0] stage1_right = {msb, q[63:1]};
    // Select shift direction for stage1: amount[1] is direction (0:left,1:right)
    wire [63:0] stage1_out = (amount[1] == 1'b0) ? stage1_left : stage1_right;

    // Stage 2: shift by 8 bits
    // For left shift by 8: shift stage1_out left by 8, zero fill
    wire [63:0] stage2_left  = {stage1_out[55:0], 8'b0};
    // For arithmetic right shift by 8: replicate msb of stage1_out, shift right by 8
    wire        stage1_msb = stage1_out[63];
    wire [63:0] stage2_right = {{8{stage1_msb}}, stage1_out[63:8]};
    // Select shift direction for stage2: same as stage1
    // But shift amount depends on amount[0]: 0 means no shift by 8 (pass stage1_out), 1 means shift by 8
    wire [63:0] stage2_out = (amount[0] == 1'b0) ? stage1_out :
                            ((amount[1] == 1'b0) ? stage2_left : stage2_right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2_out;
        else
            q <= q;
    end

endmodule