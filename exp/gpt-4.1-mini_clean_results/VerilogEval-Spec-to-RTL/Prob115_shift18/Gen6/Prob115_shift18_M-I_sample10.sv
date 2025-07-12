module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];       // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0 or 1 bit shift amount in stage 1

    // Stage 1 shift by 1 bit (if amount[0] == 1)
    wire [63:0] left_shift_1 = {q[62:0], 1'b0};
    wire [63:0] arith_right_shift_1 = { q[63], q[63:1] };

    wire [63:0] stage1_left  = shift_by_8 ? left_shift_1 : q;         // shift by 1 if amount[0]=1 else no shift
    wire [63:0] stage1_right = shift_by_8 ? arith_right_shift_1 : q; // arithmetic shift right by 1 if amount[0]=1 else no shift

    // Stage 2 shift by 8 bits (if amount[1] == 1)
    wire [63:0] left_shift_8 = {stage1_left[55:0], 8'b0};
    wire [63:0] arith_right_shift_8 = { {8{stage1_right[63]}}, stage1_right[63:8] };

    wire [63:0] shifted_left  = dir ? 64'b0 : (shift_by_8 ? left_shift_8 : stage1_left);
    wire [63:0] shifted_right = dir ? arith_right_shift_8 : 64'b0;

    // Final mux between left and right shift based on dir
    wire [63:0] shifted = dir ? arith_right_shift_8 : left_shift_8;

    // Actually, the above code tries to merge shift stages; let's reorganize cleanly:

    // Implement staged barrel shifter:

    // Step 1: shift by amount[0] (1 or 0)
    wire [63:0] left_shift_by_1 = {q[62:0], 1'b0};
    wire [63:0] right_shift_by_1 = {q[63], q[63:1]};

    wire [63:0] after_stage1 = amount[0] ? (dir ? right_shift_by_1 : left_shift_by_1) : q;

    // Step 2: shift by amount[1] (8 or 0)
    wire [63:0] left_shift_by_8 = {after_stage1[55:0], 8'b0};
    wire [63:0] right_shift_by_8 = { {8{after_stage1[63]}}, after_stage1[63:8]};

    wire [63:0] after_stage2 = amount[1] ? (dir ? right_shift_by_8 : left_shift_by_8) : after_stage1;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= after_stage2;
        // else hold q
    end

endmodule