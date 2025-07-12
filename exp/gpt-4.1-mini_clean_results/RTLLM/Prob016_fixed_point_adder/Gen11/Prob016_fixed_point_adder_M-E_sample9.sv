module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits (fractional precision)
    parameter integer N = 16           // Total bit width including sign bit
)(
    input  wire signed [N-1:0] a,      // Signed fixed-point operand a
    input  wire signed [N-1:0] b,      // Signed fixed-point operand b
    output reg  signed [N-1:0] c       // Signed fixed-point addition result
);

    // Intermediate sum with one extra bit to detect overflow
    wire signed [N:0] sum_ext;

    // Saturation limits based on N-bit signed fixed-point
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};       // Max positive value: 0 followed by all 1s
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};       // Min negative value: 1 followed by all 0s (most negative)

    assign sum_ext = a + b;

    always @* begin
        // Overflow detection for signed addition
        // Overflow occurs if sign of a == sign of b but sign of sum != sign of a
        if ((a[N-1] == b[N-1]) && (sum_ext[N] != a[N-1])) begin
            // Saturate to max or min depending on sign of inputs
            if (a[N-1] == 1'b0)
                c = MAX_VAL; // Positive overflow saturation
            else
                c = MIN_VAL; // Negative overflow saturation
        end else begin
            // No overflow, assign lower N bits (dropping extra sign bit)
            c = sum_ext[N-1:0];
        end
    end

endmodule