module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire dir_right = amount[1];  // 0 = left shift, 1 = arithmetic right shift
    wire shift_8  = amount[0];  // shift by 8 if set, else by 1

    // Shift by 1 or 8 bits, left shifts zero-fill, right shifts sign-extend

    // Left shifts (zero-fill)
    wire [63:0] left_shift_1  = {q[62:0], 1'b0};
    wire [63:0] left_shift_8  = {q[55:0], 8'd0};
    wire [63:0] left_shifted  = shift_8 ? left_shift_8 : left_shift_1;

    // Arithmetic right shifts (sign-extend)
    wire [63:0] right_shift_1 = {q[63], q[63:1]};
    wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};
    wire [63:0] right_shifted = shift_8 ? right_shift_8 : right_shift_1;

    // Select shifted value by direction
    wire [63:0] shifted_value = dir_right ? right_shifted : left_shifted;

    // Gated shifted value - only valid when ena is high
    wire [63:0] next_value = ena ? shifted_value : q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_value;
        end
    end

endmodule