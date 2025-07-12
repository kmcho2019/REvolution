module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (default)
    parameter integer N = 16          // Total bits including sign (default)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Perform signed addition with one extra bit for overflow detection
    wire signed [N:0] sum_ext = {a_s[N-1], a_s} + {b_s[N-1], b_s};

    // Extract truncated sum (N bits)
    wire signed [N-1:0] sum_trunc = sum_ext[N-1:0];

    // Overflow detection for signed addition:
    // Overflow occurs if operands have the same sign but result sign differs
    wire overflow = (~(a_s[N-1] ^ b_s[N-1])) & (a_s[N-1] ^ sum_trunc[N-1]);

    // Define saturation limits (max and min signed fixed-point values)
    localparam signed [N-1:0] SAT_POS = {1'b0, {(N-1){1'b1}}}; // Max positive value
    localparam signed [N-1:0] SAT_NEG = {1'b1, {(N-1){1'b0}}}; // Max negative value (most negative)

    reg signed [N-1:0] res;

    always @* begin
        if (overflow) begin
            // On overflow, saturate to max positive if inputs positive,
            // else saturate to max negative if inputs negative.
            if (a_s[N-1] == 1'b0)
                res = SAT_POS;
            else
                res = SAT_NEG;
        end else begin
            res = sum_trunc;
        end
        c = res;
    end

endmodule

/*
Example instantiation with parameters:

fixed_point_adder #(
    .Q(8),
    .N(16)
) my_adder (
    .a(input_a),
    .b(input_b),
    .c(output_c)
);

If parameters differ, specify them accordingly during instantiation.
*/