module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    wire a_sign = a_s[N-1];
    wire b_sign = b_s[N-1];

    // Compute absolute values using conditional expressions
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    wire same_sign = (a_sign == b_sign);

    // Result signals
    reg [N-1:0] res_mag;
    reg        res_sign;

    always @(*) begin
        if (same_sign) begin
            // Same sign: add absolute values, sign unchanged
            res_mag = a_abs + b_abs;
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller from larger magnitude
            if (a_abs >= b_abs) begin
                res_mag = a_abs - b_abs;
                res_sign = a_sign;
            end else begin
                res_mag = b_abs - a_abs;
                res_sign = b_sign;
            end
        end

        // If result magnitude is zero, force sign to positive
        if (res_mag == 0)
            res_sign = 1'b0;
    end

    // Convert back to two's complement signed number
    wire [N-1:0] res_twos_comp = res_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res_twos_comp;

endmodule