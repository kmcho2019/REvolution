module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Intermediate signals for barrel shift stages
    wire [63:0] shift_8, shift_0; // after shifting by 8 bits and by 1 bit
    wire        dir_right = amount[1]; // 0: left shift, 1: right shift
    wire        shift_8bit = amount[0]; // 0: shift by 1, 1: shift by 8

    // Stage 1: shift by 8 bits or 0 bits (pass through)
    // If left shift: shift left by 8 bits, fill with zeros
    // If right shift: shift right by 8 bits, arithmetic with sign extension
    // If shift_8bit=0, pass through unchanged
    wire [63:0] shift_by_8_left  = {q[55:0], 8'b0};
    wire [63:0] shift_by_8_right = {{8{q[63]}}, q[63:8]};
    wire [63:0] shift_8_stage = shift_8bit ?
                                (dir_right ? shift_by_8_right : shift_by_8_left) : q;

    // Stage 2: shift by 1 bit or 0 bits (pass through)
    // If left shift: shift left by 1 bit, fill with 0
    // If right shift: arithmetic shift right by 1, fill with sign bit
    wire [63:0] shift_by_1_left  = {shift_8_stage[62:0], 1'b0};
    wire [63:0] shift_by_1_right = {shift_8_stage[63], shift_8_stage[63:1]};
    wire [63:0] shift_1_stage = shift_8bit ?
                               shift_8_stage : // if shifting by 8, no 1-bit shift now
                               (dir_right ? shift_by_1_right : shift_by_1_left);

    wire [63:0] next_val = (load) ? data : (ena ? shift_1_stage : q);

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule