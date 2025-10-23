module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Direction: 0 = left, 1 = right
    wire dir = amount[1];
    // Amount bit: 0 = shift by 1, 1 = shift by 8
    wire amt = amount[0];

    // Left shifts broken into two stages:
    // Stage 1: shift by 8 bits if amt=1 else no shift
    wire [63:0] left_shift_8 = q << 8;
    wire [63:0] left_stage1 = amt ? left_shift_8 : q;
    // Stage 2: shift by 1 bit if direction=0 and amt=0 else no shift
    wire [63:0] left_shift_1 = left_stage1 << 1;
    wire [63:0] left_final = (dir == 1'b0 && amt == 1'b0) ? left_shift_1 : left_stage1;

    // Right arithmetic shifts broken into two stages:
    // Stage 1: shift right by 8 bits with sign extension if amt=1 else no shift
    wire [63:0] right_shift_8 = {{8{msb}}, q[63:8]};
    wire [63:0] right_stage1 = amt ? right_shift_8 : q;
    // Stage 2: shift right by 1 bit with sign extension if direction=1 and amt=0 else no shift
    wire [63:0] right_shift_1 = {msb, right_stage1[63:1]};
    wire [63:0] right_final = (dir == 1'b1 && amt == 1'b0) ? right_shift_1 : right_stage1;

    // Select final shifted value based on direction bit
    wire [63:0] shifted = (dir == 1'b0) ? left_final : right_final;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule