module fixed_point_subtractor #(
    parameter Q = 8,        // Number of fractional bits
    parameter N = 16        // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg signed [N-1:0] res;

    // Internal signals for signed inputs
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Extract signs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of inputs
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitude for different sign case
    wire a_abs_greater = (a_abs > b_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a - b
            // Sign of result same as inputs
            res = a_signed - b_signed;
        end else begin
            // Different sign: Add absolute values
            // Determine sign based on magnitude comparison
            reg [N-1:0] sum_abs;
            sum_abs = a_abs + b_abs;

            if (a_sign == 0 && b_sign == 1) begin
                // a positive, b negative
                // Result sign: positive if a_abs > b_abs else negative
                if (a_abs_greater) begin
                    res = sum_abs; // positive sign
                end else begin
                    // Negative result: two's complement of sum_abs
                    res = -$signed({1'b0, sum_abs[N-2:0]});
                    // Using signed to convert to negative number
                    // But simpler to do two's complement manually
                    res = (~sum_abs + 1'b1);
                end
            end else if (a_sign == 1 && b_sign == 0) begin
                // a negative, b positive
                // Result sign: negative if a_abs > b_abs else positive
                if (a_abs_greater) begin
                    // Negative result: two's complement of sum_abs
                    res = (~sum_abs + 1'b1);
                end else begin
                    res = sum_abs;
                end
            end else begin
                // Should never occur, but default
                res = a_signed - b_signed;
            end
        end

        // Handle zero result sign bit explicitly to 0
        if (res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end

        c = res;
    end

endmodule