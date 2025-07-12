module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-1:0] res;

    // Internal signals for sign and absolute values
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Larger absolute value and comparison
    wire a_greater_equal = (a_abs >= b_abs);

    // Intermediate result without sign bit
    reg [N-2:0] magnitude;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            {res[N-1], magnitude} = {1'b0, a_abs[N-2:0]} + {1'b0, b_abs[N-2:0]};
            // The addition can overflow bit N-1 of magnitude,
            // but since inputs are N bits including sign, carry out wraps.
            // Final sign is same as inputs
            res[N-1] = a_sign;
            // Assign magnitude bits (handle carry)
            res[N-2:0] = magnitude;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_greater_equal) begin
                magnitude = a_abs[N-2:0] - b_abs[N-2:0];
                res[N-1] = a_sign ? 1'b1 : (magnitude == 0 ? 1'b0 : 1'b0);
                // If magnitude == 0, set sign to 0 (positive zero)
                res[N-2:0] = magnitude;
            end else begin
                magnitude = b_abs[N-2:0] - a_abs[N-2:0];
                res[N-1] = b_sign ? 1'b1 : (magnitude == 0 ? 1'b0 : 1'b0);
                res[N-2:0] = magnitude;
            end
        end

        c = res;
    end

endmodule