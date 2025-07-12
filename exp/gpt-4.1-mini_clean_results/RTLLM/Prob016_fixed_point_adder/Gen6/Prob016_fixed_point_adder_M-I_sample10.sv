module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Perform addition with one extra bit for overflow detection
    wire signed [N:0] sum_ext = {a_s[N-1], a_s} + {b_s[N-1], b_s};

    // Result after addition (discarding overflow bit)
    wire signed [N-1:0] sum = sum_ext[N-1:0];

    // Overflow detection:
    // Overflow occurs if inputs have same sign but result sign differs
    wire overflow = (~(a_s[N-1] ^ b_s[N-1])) & (a_s[N-1] ^ sum[N-1]);

    // Calculate saturation limits dynamically:
    // Max positive value:  2^(N-1) - 1, Min negative value: -2^(N-1)
    localparam signed [N-1:0] MAX_VAL = (1 << (N - 1)) - 1;
    localparam signed [N-1:0] MIN_VAL = - (1 << (N - 1));

    always @* begin
        if (overflow) begin
            // Saturate result on overflow
            c = a_s[N-1] ? MIN_VAL : MAX_VAL;
        end else begin
            c = sum;
        end
    end

endmodule