module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;
    reg [N-1:0] temp_sum;

    always @(*) begin
        // Extract signs and magnitudes
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag = a[N-2:0];
        b_mag = b[N-2:0];

        if (a_sign == b_sign) begin
            // Both same sign - add magnitudes
            temp_sum = {1'b0, a_mag} + {1'b0, b_mag};
            
            // Check for overflow
            if (temp_sum[N-1]) begin
                // Overflow occurred, saturate to maximum value with correct sign
                res = {a_sign, {(N-1){1'b1}}};
            end else begin
                // No overflow, set result with original sign
                res = {a_sign, temp_sum[N-2:0]};
            end
        end else begin
            // Different signs - subtract smaller from larger
            if (a_mag > b_mag) begin
                res = {1'b0, a_mag - b_mag};
                // Set sign to match a's sign if result is non-zero
                if (a_mag != b_mag) res[N-1] = a_sign;
            end else if (b_mag > a_mag) begin
                res = {1'b0, b_mag - a_mag};
                // Set sign to match b's sign if result is non-zero
                if (b_mag != a_mag) res[N-1] = b_sign;
            end else begin
                // Equal magnitudes, result is zero
                res = {N{1'b0}};
            end
        end

        c = res;
    end

endmodule