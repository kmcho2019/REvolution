module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total bits including sign
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values: if negative, take two's complement
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    wire a_ge_b = (a_abs >= b_abs);

    reg [N:0] sum_ext;  // One extra bit for carry
    reg [N:0] diff_ext; // One extra bit for subtraction result (signed)
    reg result_sign;
    reg [N-1:0] result_mag;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            sum_ext = {1'b0, a_abs} + {1'b0, b_abs};
            // result sign is the same as inputs
            result_sign = a_sign;
            // Truncate sum to N bits; ignore carry out for wrap-around
            result_mag = sum_ext[N-1:0];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_ge_b) begin
                diff_ext = {1'b0, a_abs} - {1'b0, b_abs};
                result_sign = (diff_ext[N-1:0] == 0) ? 1'b0 : a_sign;
                result_mag = diff_ext[N-1:0];
            end else begin
                diff_ext = {1'b0, b_abs} - {1'b0, a_abs};
                result_sign = (diff_ext[N-1:0] == 0) ? 1'b0 : b_sign;
                result_mag = diff_ext[N-1:0];
            end
        end

        c = {result_sign, result_mag[N-2:0]};
    end

endmodule