module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];        // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    wire msb = q[63];

    // Stage 1: shift by 0 or 8 bits
    wire [63:0] stage1_left  = shift_by_8 ? {q[55:0], 8'b0} : q;
    wire [63:0] stage1_right = shift_by_8 ? {{8{msb}}, q[63:8]} : q;

    // Stage 2: shift by 0 or 1 bit
    wire [63:0] stage2_left  = {stage1_left[62:0], 1'b0};
    wire [63:0] stage2_right = {msb, stage1_right[63:1]};

    // Select output of stage 2 shift amount
    wire [63:0] left_shifted  = shift_by_8 ? stage1_left  : stage2_left;
    wire [63:0] right_shifted = shift_by_8 ? stage1_right : stage2_right;

    // Final selected shift value based on direction
    wire [63:0] shifted = dir ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold q
    end

endmodule