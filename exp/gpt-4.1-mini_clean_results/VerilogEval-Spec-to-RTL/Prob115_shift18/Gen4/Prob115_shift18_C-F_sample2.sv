module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Direction: 0 = left shift, 1 = arithmetic right shift
    wire dir_right = amount[1];
    // Shift amount: 0 = shift by 1, 1 = shift by 8 (encoded in amount[0])
    wire shift_8 = amount[0];

    // Left shifts (fill zeros)
    wire [63:0] left_shift_1  = {q[62:0], 1'b0};
    wire [63:0] left_shift_8  = {q[55:0], 8'd0};
    wire [63:0] left_shifted  = shift_8 ? left_shift_8 : left_shift_1;

    // Arithmetic right shifts (sign-extend MSB)
    wire [63:0] right_shift_1 = {q[63], q[63:1]};
    wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};
    wire [63:0] right_shifted = shift_8 ? right_shift_8 : right_shift_1;

    // Final shifted value mux based on direction
    wire [63:0] shifted = dir_right ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule