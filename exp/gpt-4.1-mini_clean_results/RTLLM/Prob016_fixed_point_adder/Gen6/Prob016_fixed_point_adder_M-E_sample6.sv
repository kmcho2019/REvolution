module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total number of bits including sign
)(
    input  wire [N-1:0] a,          // Fixed-point input operand A
    input  wire [N-1:0] b,          // Fixed-point input operand B
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Signed versions of inputs for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Intermediate signed result with one extra bit for overflow detection
    reg signed [N:0] sum_extended;

    // Saturation limits for N-bit signed fixed-point
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};             // Max positive number: 0 followed by all ones
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};             // Min negative number: 1 followed by all zeros (two's complement min)

    // Internal register to store the final saturated result
    reg signed [N-1:0] res;

    always @* begin
        // 1) Perform signed addition using extended width to catch overflow
        sum_extended = a_signed + b_signed;

        // 2) Saturate the result if overflow or underflow occurs
        if (sum_extended > MAX_VAL) begin
            res = MAX_VAL;
        end else if (sum_extended < MIN_VAL) begin
            res = MIN_VAL;
        end else begin
            // No overflow: take lower N bits
            res = sum_extended[N-1:0];
        end

        // 3) Assign to output port
        c = res;
    end

endmodule