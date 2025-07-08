module fixed_point_subtractor #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Magnitudes (absolute values) of a and b
    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    reg [N-1:0] mag_res;
    reg sign_res;

    always @(*) begin
        // Case 1: same sign => subtraction of magnitudes
        if (sign_a == sign_b) begin
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = ~sign_a; // opposite sign since we swap operands
            end
        end
        // Case 2: different sign => addition of magnitudes
        else begin
            mag_res = mag_a + mag_b;
            // Determine sign of result by comparing magnitudes
            if (mag_a >= mag_b)
                sign_res = sign_a;
            else
                sign_res = sign_b;
        end

        // When result is zero, sign bit forced to 0
        if (mag_res == 0)
            sign_res = 1'b0;

        // Compose final result with sign and magnitude (two's complement)
        if (sign_res == 1'b1) begin
            // negative result: two's complement of magnitude
            res = ~mag_res + 1'b1;
        end else begin
            // positive result: magnitude as is
            res = mag_res;
        end
        c = res;
    end

endmodule