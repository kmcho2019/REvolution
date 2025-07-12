module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: shift by 8 bits or pass-through
    // For left shifts:
    wire [63:0] left_shift_8  = {q[55:0], 8'b0};
    wire [63:0] left_stage1   = (amount == 2'b01) ? left_shift_8 : q;

    // For right shifts:
    wire [63:0] right_shift_8 = {{8{msb}}, q[63:8]};
    wire [63:0] right_stage1  = (amount == 2'b11) ? right_shift_8 : q;

    // Select stage 1 output based on direction bit
    wire [63:0] stage1_out = (amount[1] == 1'b0) ? left_stage1 : right_stage1;

    // Stage 2: shift by 1 bit or pass-through
    // Left shift by 1
    wire [63:0] left_shift_1 = {stage1_out[62:0], 1'b0};

    // Arithmetic right shift by 1
    wire stage2_msb = stage1_out[63];
    wire [63:0] right_shift_1 = {stage2_msb, stage1_out[63:1]};

    // Determine if stage 2 shift by 1 is needed
    // amount values that need shift by 1 bit:
    // 2'b00 (left 1)
    // 2'b10 (right 1)
    // Otherwise no shift in stage 2
    wire stage2_shift_1 = (amount == 2'b00) || (amount == 2'b10);

    // Select between left and right 1-bit shift in stage 2, or pass-through
    wire [63:0] stage2_shifted = (stage2_shift_1) ? 
                                ((amount[1] == 1'b0) ? left_shift_1 : right_shift_1) 
                                : stage1_out;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2_shifted;
    end

endmodule