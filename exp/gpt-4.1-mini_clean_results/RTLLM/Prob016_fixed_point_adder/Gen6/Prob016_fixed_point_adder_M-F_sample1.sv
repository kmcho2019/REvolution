module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total bits including sign bit
)(
    input  wire [N-1:0] a,       // Fixed-point input a
    input  wire [N-1:0] b,       // Fixed-point input b
    output reg  [N-1:0] c        // Fixed-point output c
);

    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Perform addition with one extra bit for overflow detection
    wire signed [N:0] sum_ext = {a_s[N-1], a_s} + {b_s[N-1], b_s};

    // Truncated sum (N bits)
    wire signed [N-1:0] sum = sum_ext[N-1:0];

    // Overflow detection:
    // Overflow if inputs have the same sign but sum sign differs
    wire overflow = (~(a_s[N-1] ^ b_s[N-1])) & (a_s[N-1] ^ sum[N-1]);

    // Define saturation limits for N-bit signed fixed-point number
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};    // Maximum positive value (e.g., 011...1)
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};    // Maximum negative value (e.g., 100...0)

    always @(*) begin
        if (overflow) begin
            // Saturate to min or max depending on sign of inputs (same sign)
            c = a_s[N-1] ? MIN_VAL : MAX_VAL;
        end else begin
            c = sum;
        end
    end

endmodule