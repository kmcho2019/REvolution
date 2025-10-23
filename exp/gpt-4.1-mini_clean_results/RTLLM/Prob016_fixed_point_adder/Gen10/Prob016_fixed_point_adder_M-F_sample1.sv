module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits (precision)
    parameter integer N = 16        // Total number of bits including sign
)(
    input  wire signed [N-1:0] a,  // Fixed-point input operand A (two's complement signed)
    input  wire signed [N-1:0] b,  // Fixed-point input operand B (two's complement signed)
    output reg  signed [N-1:0] c   // Fixed-point addition result (two's complement signed)
);

    // Local parameters for saturation limits
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // Max positive:  2^(N-1)-1
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // Min negative: -2^(N-1)

    // Intermediate wider result to detect overflow (N+1 bits signed)
    wire signed [N:0] sum_ext = a + b;

    always @(*) begin
        // Saturate the result on overflow:
        // - If sum_ext > MAX_VAL => c = MAX_VAL
        // - If sum_ext < MIN_VAL => c = MIN_VAL
        // Else => c = sum_ext[N-1:0] (lower N bits)
        if (sum_ext > MAX_VAL)
            c = MAX_VAL;
        else if (sum_ext < MIN_VAL)
            c = MIN_VAL;
        else
            c = sum_ext[N-1:0];
    end

endmodule