module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];       // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    // Stage 1: shift by 0 or 8 bits
    // Left shift stage 1: shift by 8 or no shift
    wire [63:0] left_shift_stage1 = shift_by_8 ? {q[55:0], 8'b0} : q;
    // Arithmetic right shift stage 1: shift by 8 or no shift with sign extension
    wire [63:0] right_shift_stage1 = shift_by_8 ? { {8{q[63]}}, q[63:8] } : q;

    // Stage 2: shift by 0 or 1 bit
    // Left shift stage 2: shift by 1 or no shift
    wire [63:0] left_shift_stage2 = {left_shift_stage1[62:0], 1'b0};
    // Arithmetic right shift stage 2: shift by 1 or no shift with sign extension
    wire [63:0] right_shift_stage2 = { {1{left_shift_stage1[63]}}, left_shift_stage1[63:1] };

    // Select shift by 1 or no shift for stage 2 based on ~shift_by_8 (since stage1 already handled 8)
    wire [63:0] left_shifted = shift_by_8 ? left_shift_stage1 : left_shift_stage2;
    wire [63:0] right_shifted = shift_by_8 ? right_shift_stage1 : right_shift_stage2;

    wire [63:0] shifted = dir ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold q
    end

endmodule