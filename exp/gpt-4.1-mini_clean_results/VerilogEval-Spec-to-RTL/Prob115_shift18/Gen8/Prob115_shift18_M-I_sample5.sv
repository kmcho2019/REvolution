module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    wire shift_dir = amount[1];     // 0: left, 1: right arithmetic
    wire shift_by_8 = amount[0];   // 0: shift by 1, 1: shift by 8

    // Step 1: shift by 8 or no shift
    // Left shift by 8 bits or no shift
    wire [63:0] left_shift_8  = {q[55:0], 8'b0};
    // Arithmetic right shift by 8 bits or no shift
    wire [63:0] arith_right_shift_8 = { {8{q[63]}}, q[63:8] };

    // Select shift by 8 or no shift based on amount[0]
    wire [63:0] step8_shifted_left  = shift_by_8 ? left_shift_8  : q;
    wire [63:0] step8_shifted_right = shift_by_8 ? arith_right_shift_8 : q;

    // Step 2: shift by 1 or no shift on result of step 1
    // Left shift by 1 bit or no shift
    wire [63:0] left_shift_1 = {step8_shifted_left[62:0], 1'b0};
    // Arithmetic right shift by 1 bit or no shift
    wire [63:0] arith_right_shift_1 = { {1{step8_shifted_right[63]}}, step8_shifted_right[63:1] };

    wire [63:0] shifted_left  = shift_by_8 ? step8_shifted_left : left_shift_1;
    wire [63:0] shifted_right = shift_by_8 ? step8_shifted_right : arith_right_shift_1;

    // Final shifted value depending on direction
    wire [63:0] shifted = shift_dir ? shifted_right : shifted_left;

    // Compute next value of q
    wire [63:0] next_q = load ? data : (ena ? shifted : q);

    // Only update q on clk when load or ena active to reduce toggling (clock gating at RTL level)
    always @(posedge clk) begin
        if (load || ena)
            q <= next_q;
    end

endmodule