module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire dir_right = amount[1];   // 0 = left, 1 = arithmetic right
    wire shift_8  = amount[0];   // shift by 8 if set, else by 1 (or 0 if none)
    
    // Calculate shift distances
    // Left shifts: 1 (amount=00) or 8 (amount=01)
    // Right shifts: 1 (10) or 8 (11)
    wire [5:0] shift_amt = shift_8 ? 6'd8 : 6'd1;

    // Arithmetic right shift with sign extension
    // Left shift pads zeros, right shift pads sign bit (q[63])
    
    wire [63:0] left_shifted;
    wire [63:0] arith_right_shifted;

    // Left shift by shift_amt:
    // Because shift_amt is 1 or 8, implement multiplexer based on amount
    // We'll implement a barrel shifter using mux and concat operations.

    // Left shift by 1 or 8:
    wire [63:0] left_shift_1 = {q[62:0], 1'b0};
    wire [63:0] left_shift_8 = {q[55:0], 8'd0};

    assign left_shifted = shift_8 ? left_shift_8 : left_shift_1;

    // Arithmetic right shift by 1 or 8 with sign extension:
    // Sign bit replicated for bits shifted in.

    // Right shift by 1:
    wire [63:0] right_shift_1 = {q[63], q[63:1]};
    // Right shift by 8:
    wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};

    assign arith_right_shifted = shift_8 ? right_shift_8 : right_shift_1;

    // Select final shifted value based on direction
    wire [63:0] shifted = dir_right ? arith_right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule