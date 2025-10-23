module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Internal signals for sign bits and magnitudes
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Calculate magnitudes (absolute values) of a and b
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Compare magnitudes
    wire a_greater_eq_b = (mag_a >= mag_b);

    // Sum and difference of magnitudes with 1 extra bit to prevent overflow in intermediate calculations
    wire [N-1:0] mag_sum  = {1'b0, mag_a} + {1'b0, mag_b};
    wire [N-1:0] mag_diff = a_greater_eq_b ? ({1'b0, mag_a} - {1'b0, mag_b}) : ({1'b0, mag_b} - {1'b0, mag_a});

    // Combinational logic to compute result
    always @* begin
        if (sign_a == sign_b) begin
            // Same signs: add magnitudes, keep sign
            // If mag_sum overflows N-1 bits, truncate (overflow wraparound)
            res[N-1] = sign_a;
            res[N-2:0] = mag_sum[N-2:0];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_greater_eq_b) begin
                // Result sign is sign of a
                // Positive zero case handled later
                if (mag_diff == 0) begin
                    // Zero result: force positive zero
                    res = {1'b0, {(N-1){1'b0}}};
                end else begin
                    // For sign_a=1 (negative), store two's complement
                    if (sign_a == 1'b0) begin
                        // Positive sign: magnitude directly
                        res = {1'b0, mag_diff[N-2:0]};
                    end else begin
                        // Negative sign: two's complement
                        res = {1'b1, (~mag_diff[N-2:0] + 1'b1)};
                    end
                end
            end else begin
                // Result sign is sign of b
                if (mag_diff == 0) begin
                    // Zero result: force positive zero
                    res = {1'b0, {(N-1){1'b0}}};
                end else begin
                    if (sign_b == 1'b0) begin
                        // Positive sign: magnitude directly
                        res = {1'b0, mag_diff[N-2:0]};
                    end else begin
                        // Negative sign: two's complement
                        res = {1'b1, (~mag_diff[N-2:0] + 1'b1)};
                    end
                end
            end
        end
    end

    // Assign output
    assign c = res;

endmodule