module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode direction and shift amount
    // direction: 0 = left shift, 1 = arithmetic right shift
    wire dir_right = amount[1];
    // shift amount selection (0 = shift by 1, 1 = shift by 8)
    wire shift_8 = amount[0];
    wire shift_1 = ~shift_8;

    // Stage 1: 8-bit shift or pass-through (only one direction computed)
    wire [63:0] stage1_left  = shift_8 ? (q << 8)  : q;
    wire [63:0] stage1_right = shift_8 ? ({{8{q[63]}}, q[63:8]}) : q;

    wire [63:0] stage1 = dir_right ? stage1_right : stage1_left;

    // Stage 2: 1-bit shift or pass-through (applies only if shift_1 is active)
    wire [63:0] stage2_left  = shift_1 ? (stage1 << 1)  : stage1;
    wire [63:0] stage2_right = shift_1 ? ({stage1[63], stage1[63:1]}) : stage1;

    wire [63:0] shifted = dir_right ? stage2_right : stage2_left;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule