module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Decompose shifts into two stages:
    // Stage 1: shift by 8 bits or no shift
    wire [63:0] shift_8_left  = {q[55:0], 8'b0};
    wire [63:0] shift_8_right = {{8{msb}}, q[63:8]};
    wire [63:0] stage1_shift_left  = (amount[0]) ? shift_8_left  : q;
    wire [63:0] stage1_shift_right = (amount[0]) ? shift_8_right : q;

    // Stage 2: shift by 1 bit or no shift on the stage1 result
    wire [63:0] stage2_shift_left  = {stage1_shift_left[62:0], 1'b0};
    wire [63:0] stage2_shift_right = {stage1_shift_right[63], stage1_shift_right[63:1]};

    // Select direction based on amount[1]: 0 = left shift, 1 = right shift
    wire [63:0] shifted = (amount[1] == 1'b0) ? stage2_shift_left : stage2_shift_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule