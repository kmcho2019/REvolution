module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire direction = amount[1];   // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];  // 0: shift by 1, 1: shift by 8
    wire [5:0] shift_val = shift_by_8 ? 6'd8 : 6'd1;

    wire sign_bit = q[63];

    // Shift result depending on direction:
    // Use single arithmetic right shift with sign extension replicated dynamically

    // Construct arithmetic right shift operand with sign extension
    // For right shift: fill upper bits with sign_bit repeated 'shift_val' times, then append upper bits of q
    // For left shift: simple left shift

    wire [63:0] arith_right_shifted = { {64{sign_bit}} << (64 - shift_val), q } >> shift_val;

    // For left shift, just shift left by shift_val
    wire [63:0] left_shifted = q << shift_val;

    wire [63:0] shifted = direction ? arith_right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule