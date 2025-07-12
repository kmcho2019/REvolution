module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Interpret inputs and output as signed values for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform addition with one extra bit for overflow detection
    wire signed [N:0] sum_ext = {a_signed[N-1], a_signed} + {b_signed[N-1], b_signed};

    // Extract result and overflow flags
    wire signed [N-1:0] sum = sum_ext[N-1:0];

    // Overflow detection for signed addition:
    // Overflow if sign of a == sign of b but sign of sum != sign of a
    wire overflow = (~(a[N-1] ^ b[N-1])) & (a[N-1] ^ sum[N-1]);

    // Saturation values for fixed-point range
    localparam signed [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};  // max positive
    localparam signed [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};  // max negative (min value)

    // Result register
    reg signed [N-1:0] res;

    always @(*) begin
        if (overflow) begin
            // Saturate on overflow to max positive or max negative
            if (a[N-1] == 1'b0) begin
                // Overflow positive direction: saturate to max positive
                res = MAX_POS;
            end else begin
                // Overflow negative direction: saturate to max negative
                res = MAX_NEG;
            end
        end else begin
            res = sum;
        end
    end

    // Output assignment
    always @(*) begin
        c = res;
    end

endmodule