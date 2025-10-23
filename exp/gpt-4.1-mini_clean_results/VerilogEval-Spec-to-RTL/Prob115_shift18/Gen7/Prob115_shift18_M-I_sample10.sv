module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Extract control signals
    wire direction = amount[1];  // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    // Generate shift amount in bits
    wire [5:0] shift_val = shift_by_8 ? 6'd8 : 6'd1;

    // Left shift results
    wire [63:0] left_shift_1  = q << 1;
    wire [63:0] left_shift_8  = q << 8;

    // Arithmetic right shift results: sign extend once
    wire sign_bit = q[63];
    wire [63:0] arith_right_shift_1 = { {1{sign_bit}}, q[63:1] };
    wire [63:0] arith_right_shift_8 = { {8{sign_bit}}, q[63:8] };

    // Select shift by amount (1 or 8) for left and right
    wire [63:0] left_shifted = shift_by_8 ? left_shift_8 : left_shift_1;
    wire [63:0] right_shifted = shift_by_8 ? arith_right_shift_8 : arith_right_shift_1;

    // Select shift direction
    wire [63:0] shifted = direction ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule