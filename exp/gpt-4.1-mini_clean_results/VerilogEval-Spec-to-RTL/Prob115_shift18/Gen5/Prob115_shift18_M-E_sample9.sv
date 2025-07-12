module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire dir = amount[1];   // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    // Arithmetic right shift with sign extension by 1 or 8 bits
    wire [63:0] arith_right_1 = { {1{q[63]}}, q[63:1] };
    wire [63:0] arith_right_8 = { {8{q[63]}}, q[63:8] };
    wire [63:0] arith_right_shifted = shift_by_8 ? arith_right_8 : arith_right_1;

    // Logical left shift by 1 or 8 bits (fill with zeros)
    wire [63:0] left_shift_1 = {q[62:0], 1'b0};
    wire [63:0] left_shift_8 = {q[55:0], 8'b0};
    wire [63:0] left_shifted = shift_by_8 ? left_shift_8 : left_shift_1;

    // Select output shift based on direction
    wire [63:0] shifted = dir ? arith_right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold q
    end

endmodule