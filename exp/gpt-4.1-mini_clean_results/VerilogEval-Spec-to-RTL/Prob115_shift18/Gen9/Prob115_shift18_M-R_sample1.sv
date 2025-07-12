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

    wire [63:0] stage1_left  = shift_by_8 ? {q[55:0], 8'b0}     : q;
    wire [63:0] stage1_right = shift_by_8 ? {{8{q[63]}}, q[63:8]} : q;

    wire [63:0] stage2_left  = {stage1_left[62:0], 1'b0};
    wire [63:0] stage2_right = { {1{stage1_right[63]}}, stage1_right[63:1] };

    wire [63:0] shifted_left  = shift_by_8 ? stage1_left  : stage2_left;
    wire [63:0] shifted_right = shift_by_8 ? stage1_right : stage2_right;

    wire [63:0] shifted = dir ? shifted_right : shifted_left;

    // Combinational logic for next state
    reg [63:0] next_q;
    always @(*) begin
        if (load)
            next_q = data;
        else if (ena)
            next_q = shifted;
        else
            next_q = q;
    end

    // Sequential logic
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule