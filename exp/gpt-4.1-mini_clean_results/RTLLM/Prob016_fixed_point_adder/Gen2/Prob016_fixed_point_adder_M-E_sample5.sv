module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits
    parameter integer N = 16   // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,    // Fixed-point input operand a
    input  wire [N-1:0] b,    // Fixed-point input operand b
    output wire [N-1:0] c     // Fixed-point addition result
);

    // Signed versions of inputs for arithmetic
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Internal registers for computation
    reg signed [N-1:0] res;
    reg signed [N-1:0] a_abs;
    reg signed [N-1:0] b_abs;

    // Flags
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    always @(*) begin
        // Compute absolute values inline:
        // If negative, negate to get positive magnitude; else keep as is
        a_abs = a_sign ? -a_signed : a_signed;
        b_abs = b_sign ? -b_signed : b_signed;

        if (a_sign == b_sign) begin
            // Same sign: sum directly
            res = a_signed + b_signed;
        end else begin
            // Different signs: subtract smaller absolute from larger absolute
            if (a_abs >= b_abs) begin
                // Result sign = sign of a
                if (a_abs == b_abs) begin
                    // Result zero if magnitudes equal
                    res = 0;
                end else begin
                    res = a_sign ? -(a_abs - b_abs) : (a_abs - b_abs);
                end
            end else begin
                // b_abs > a_abs
                // Result sign = sign of b
                if (b_abs == a_abs) begin
                    // Result zero if magnitudes equal (handled above as well)
                    res = 0;
                end else begin
                    res = b_sign ? -(b_abs - a_abs) : (b_abs - a_abs);
                end
            end
        end
    end

    // Assign output from internal result register
    assign c = res;

endmodule