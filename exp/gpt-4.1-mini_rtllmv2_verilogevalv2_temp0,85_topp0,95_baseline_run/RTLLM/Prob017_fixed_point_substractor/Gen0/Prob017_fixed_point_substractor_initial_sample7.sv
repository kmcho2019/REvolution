module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Internal signals for sign and magnitude extraction
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Magnitude extraction (absolute values)
    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    // Comparison of magnitudes to determine result sign in different sign cases
    wire a_greater_equal_b = (mag_a >= mag_b);

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign subtraction: res = mag_a - mag_b, sign = sign_a
            if (mag_a >= mag_b) begin
                res = mag_a - mag_b;
                if (sign_a)
                    res = (~res + 1'b1); // restore sign (2's complement) if negative
            end else begin
                res = mag_b - mag_a;
                if (!sign_a)
                    res = (~res + 1'b1); // if inputs were positive and mag_b > mag_a, result is negative
                else
                    res = (~res + 1'b1); // if inputs were negative and mag_b > mag_a, result positive? Actually, inputs same sign, if mag_b > mag_a, result sign flips
            end
        end else begin
            // Different signs: res = mag_a + mag_b
            reg [N-1:0] sum_mag;
            sum_mag = mag_a + mag_b;

            if (sign_a == 0 && sign_b == 1) begin
                // a positive, b negative => result sign positive if mag_a >= mag_b else negative
                if (a_greater_equal_b) begin
                    res = sum_mag; // positive sign, just sum
                end else begin
                    res = ~sum_mag + 1'b1; // negative sign, two's complement
                end
            end else begin
                // a negative, b positive => result sign negative if mag_a >= mag_b else positive
                if (a_greater_equal_b) begin
                    res = ~sum_mag + 1'b1; // negative sign
                end else begin
                    res = sum_mag; // positive sign
                end
            end
        end

        // Handle zero result explicitly: clear sign bit
        if (res == 0) begin
            c = 0;
        end else begin
            c = res;
        end
    end

endmodule