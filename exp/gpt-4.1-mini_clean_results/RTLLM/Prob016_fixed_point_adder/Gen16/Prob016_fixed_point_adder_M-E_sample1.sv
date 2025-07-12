module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal signed extended signals to hold operands and sum
    wire signed [N:0] a_ext = {a[N-1], a}; // Sign-extend input a by 1 bit
    wire signed [N:0] b_ext = {b[N-1], b}; // Sign-extend input b by 1 bit

    wire signed [N:0] sum_ext = a_ext + b_ext; // N+1 bit sum with sign extension

    // Saturation boundaries for fixed-point signed numbers
    // Max positive value:  0x7FFF... for N bits (sign=0, all 1's)
    // Max negative value:  0x8000... for N bits (sign=1, all 0's)
    localparam signed [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam signed [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Detect overflow if sign of sum_ext differs from sign of extended operands
    wire overflow_pos = (a_ext[N] == 0) && (b_ext[N] == 0) && (sum_ext[N] == 1);
    wire overflow_neg = (a_ext[N] == 1) && (b_ext[N] == 1) && (sum_ext[N] == 0);

    always @* begin
        if (overflow_pos)
            c = MAX_POS; // Saturate to maximum positive fixed-point number
        else if (overflow_neg)
            c = MAX_NEG; // Saturate to maximum negative fixed-point number
        else
            c = sum_ext[N-1:0]; // No overflow: take lower N bits as result
    end

endmodule