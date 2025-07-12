module fixed_point_adder #(
    parameter Q = 8,      // Number of fractional bits
    parameter N = 16      // Total number of bits (integer + fractional)
) (
    input wire [N-1:0] a, // First fixed-point operand
    input wire [N-1:0] b, // Second fixed-point operand
    output reg [N-1:0] c  // Fixed-point result
);

    // Internal signals
    wire [N:0] sum_ext;   // Extended sum for overflow detection
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}}; // Maximum positive value
    wire [N-1:0] min_neg = {1'b1, {(N-1){1'b0}}}; // Minimum negative value

    // Perform addition with extended sign bit for overflow detection
    assign sum_ext = {a[N-1], a} + {b[N-1], b};

    always @(*) begin
        casex ({sum_ext[N], sum_ext[N-1]})
            2'b01:  c = max_pos;  // Positive overflow
            2'b10:  c = min_neg;  // Negative overflow
            default: c = sum_ext[N-1:0]; // Normal case
        endcase
    end

    // Note: Parameter Q is available for future fractional-specific operations
    // Currently used for documentation of fixed-point format

endmodule