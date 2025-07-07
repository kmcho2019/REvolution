module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add absolute values, keep sign
            res = a_abs + b_abs;
            // If addition overflows beyond N bits, it wraps around naturally
            // Set sign bit to original sign
            res[N-1] = a_sign;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs_ge_b_abs) begin
                // a_abs >= b_abs
                res = a_abs - b_abs;
                // Sign is sign of a
                res[N-1] = a_sign;
            end else begin
                // b_abs > a_abs
                res = b_abs - a_abs;
                // Sign is sign of b
                res[N-1] = b_sign;
            end
        end
    end

    assign c = res;

endmodule