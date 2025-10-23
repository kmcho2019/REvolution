module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Decode shift direction: 0 = left, 1 = right
    wire dir_right = amount[1];
    // Decode shift amount: lower bit indicates shift by 8 if set
    wire shift8 = amount[0];
    // shift1 is the complement of shift8 (only one of them active at a time)
    wire shift1 = ~shift8;

    // Stage 1: Shift by 8 bits if enabled
    // Left shift by 8 bits (logical)
    wire [63:0] stage1_shift8_left  = {q[55:0], 8'b0};
    // Right shift by 8 bits (arithmetic)
    wire [63:0] stage1_shift8_right = {{8{sign}}, q[63:8]};
    // If no 8-bit shift (shift1 active), stage1 passes q through unchanged
    wire [63:0] stage1_out = ena ?
        (shift8 ? (dir_right ? stage1_shift8_right : stage1_shift8_left) : q)
        : q;

    // Stage 2: Shift by 1 bit if enabled
    // Left shift by 1 bit (logical)
    wire [63:0] stage2_shift1_left  = {stage1_out[62:0], 1'b0};
    // Right shift by 1 bit (arithmetic)
    wire [63:0] stage2_shift1_right = {stage1_out[63], stage1_out[63:1]};
    // If no 1-bit shift (shift8 active), stage2 passes stage1_out through unchanged
    wire [63:0] next_shift = ena ?
        (shift1 ? (dir_right ? stage2_shift1_right : stage2_shift1_left) : stage1_out)
        : stage1_out;

    wire [63:0] next_val = load ? data : next_shift;

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule