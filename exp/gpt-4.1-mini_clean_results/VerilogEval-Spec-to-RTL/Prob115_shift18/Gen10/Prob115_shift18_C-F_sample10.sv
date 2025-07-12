module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    // Decode control signals
    wire dir_right = amount[1];    // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];   // 0: shift by 1, 1: shift by 8

    // Left shift path (only valid if dir_right==0)
    wire [63:0] left_stage1 = shift_by_8 ? {q[55:0], 8'b0} : q;       // shift by 8 or no shift
    wire [63:0] left_stage2 = {left_stage1[62:0], 1'b0};               // shift by 1 or no shift
    wire [63:0] left_shifted = shift_by_8 ? left_stage1 : left_stage2;

    // Arithmetic right shift path (only valid if dir_right==1)
    wire [63:0] right_stage1 = shift_by_8 ? {{8{q[63]}}, q[63:8]} : q;  // shift by 8 or no shift with sign extension
    wire [63:0] right_stage2 = { {1{right_stage1[63]}}, right_stage1[63:1] }; // shift by 1 or no shift with sign extension
    wire [63:0] right_shifted = shift_by_8 ? right_stage1 : right_stage2;

    // Select shifted result based on direction
    wire [63:0] shifted = dir_right ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else retain current q
    end

endmodule