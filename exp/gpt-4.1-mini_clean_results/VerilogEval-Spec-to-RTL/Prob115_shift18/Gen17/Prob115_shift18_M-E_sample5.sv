module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Left shift by 1: drop MSB, shift left, LSB filled with 0
    wire [63:0] left1 = {q[62:0], 1'b0};

    // Left shift by 8: drop top 8 bits, shift left by 8, lower 8 bits zero
    wire [63:0] left8 = {q[55:0], 8'b0};

    // Arithmetic right shift by 1: MSB filled with sign, shift right by 1
    wire [63:0] right1 = {sign, q[63:1]};

    // Arithmetic right shift by 8: MSB 8 bits filled with sign, shift right by 8
    wire [63:0] right8 = {{8{sign}}, q[63:8]};

    // Select shift by amount[0]: 0 for shift by 1, 1 for shift by 8
    wire [63:0] left_shift = (amount[0] == 1'b0) ? left1 : left8;
    wire [63:0] right_shift = (amount[0] == 1'b0) ? right1 : right8;

    // Select shift direction by amount[1]: 0 for left, 1 for right
    wire [63:0] shifted = (amount[1] == 1'b0) ? left_shift : right_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        else
            q <= q; // Hold current value if no load or enable
    end

endmodule