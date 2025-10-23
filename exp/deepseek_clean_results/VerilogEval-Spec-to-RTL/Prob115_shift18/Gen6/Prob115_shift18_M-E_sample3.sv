module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Early sign calculation
wire sign_bit = q[63];
wire [7:0] sign_byte = {8{sign_bit}};

// Shift direction and amount decoding
wire is_right_shift = amount[1];
wire is_8bit_shift = amount[0];

// Pre-shift preparation: For right shifts, we'll rotate left by (64 - shift_amount)
wire [63:0] pre_shift_value = is_right_shift ? 
    {q[0], q[63:1]} :  // Pre-rotate right 1 becomes left rotate 1
    q;                 // No pre-rotation for left shifts

// Unified shift amount calculation
wire [6:0] unified_shift_amount = 
    is_right_shift ? 
        (is_8bit_shift ? 7'd56 : 7'd63) :  // 64-8=56, 64-1=63
        (is_8bit_shift ? 7'd8 : 7'd1);     // Direct amounts for left

// Main shift operation (always left shift after preparation)
wire [63:0] shifted_value = pre_shift_value << unified_shift_amount;

// Arithmetic right shift correction
wire [63:0] right_shift_corrected = 
    is_right_shift ? 
        (is_8bit_shift ? {sign_byte, shifted_value[63:8]} : 
                         {sign_bit, shifted_value[63:1]}) :
        shifted_value;

// Next state logic with optimized load path
wire [63:0] next_q = load ? data : (ena ? right_shift_corrected : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule