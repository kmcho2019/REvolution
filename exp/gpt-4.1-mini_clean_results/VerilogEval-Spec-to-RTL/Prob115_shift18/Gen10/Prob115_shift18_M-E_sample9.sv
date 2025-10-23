module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode amount bits for clarity
    wire dir_right = amount[1]; // 0: left, 1: right (arithmetic)
    wire shift_8  = amount[0]; // 0: shift by 1, 1: shift by 8

    // Left shift candidates
    wire [63:0] left_shift_1  = {q[62:0], 1'b0};
    wire [63:0] left_shift_8  = {q[55:0], 8'b0};

    // Arithmetic right shift candidates
    wire [63:0] arith_right_shift_1 = {q[63], q[63:1]};
    wire [63:0] arith_right_shift_8 = {{8{q[63]}}, q[63:8]};

    // Select shift magnitude within direction
    wire [63:0] left_shift  = shift_8 ? left_shift_8 : left_shift_1;
    wire [63:0] right_shift = shift_8 ? arith_right_shift_8 : arith_right_shift_1;

    // Select shift direction
    wire [63:0] shifted = dir_right ? right_shift : left_shift;

    // Next state logic
    wire [63:0] next_q = load ? data : (ena ? shifted : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule