module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values: if negative, two's complement
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_ge_b = (a_abs >= b_abs);

    reg [N-1:0] result_mag;
    reg result_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            {result_sign, result_mag} = {1'b0, a_abs} + {1'b0, b_abs};
            // Ignore carry out, sign remains same as inputs
            result_sign = a_sign;
        end else begin
            // Different signs: subtract smaller from larger
            if (a_ge_b) begin
                result_mag = a_abs - b_abs;
                result_sign = (result_mag == 0) ? 1'b0 : a_sign;
            end else begin
                result_mag = b_abs - a_abs;
                result_sign = (result_mag == 0) ? 1'b0 : b_sign;
            end
        end

        // Combine sign and magnitude into output
        c = {result_sign, result_mag[N-2:0]};
    end

endmodule