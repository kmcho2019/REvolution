module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Direction: 0 = left, 1 = arithmetic right
    wire dir_right = amount[1];
    wire shift_8 = amount[0];

    // Stage 1 shift by 8 bits or 0 bits
    // Stage 2 shift by 1 bit or 0 bits
    // Total shift amount = shift_8*8 + shift_1*1 (shift_1 = ~shift_8)

    // The design shifts by 8 bits first if shift_8=1, else no shift in stage 1
    // Then shifts by 1 bit if shift_8=0, else no shift in stage 2

    // Stage 1: shift by 8 bits or 0 bits

    // Left shift by 8 bits
    wire [63:0] left_shift_8 = {q[55:0], 8'd0};
    // Arithmetic right shift by 8 bits
    wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

    wire [63:0] stage1_out = shift_8 ?
                             (dir_right ? right_shift_8 : left_shift_8)
                             : q;

    // Stage 2: shift by 1 bit or 0 bits

    // Left shift by 1 bit
    wire [63:0] left_shift_1 = {stage1_out[62:0], 1'b0};
    // Arithmetic right shift by 1 bit
    wire [63:0] right_shift_1 = {stage1_out[63], stage1_out[63:1]};

    wire [63:0] stage2_out = ~shift_8 ?
                             (dir_right ? right_shift_1 : left_shift_1)
                             : stage1_out;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= stage2_out;
        end
        // else hold q
    end

endmodule