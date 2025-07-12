module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal registers
    reg [N-2:0] mag_a, mag_b, mag_res;
    reg sign_a, sign_b, sign_res;
    reg [N-1:0] res;

    // Magnitude comparison flag
    wire a_larger;

    always @(*) begin
        // Extract signs and magnitudes
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a = sign_a ? -a[N-2:0] : a[N-2:0];
        mag_b = sign_b ? -b[N-2:0] : b[N-2:0];

        // Compare magnitudes
        a_larger = (mag_a > mag_b);

        // Perform sign-aware operation
        if (sign_a == sign_b) begin
            // Same signs: add magnitudes
            {sign_res, mag_res} = {sign_a, mag_a} + {sign_b, mag_b};
        end else begin
            // Different signs: subtract smaller from larger
            if (a_larger) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = sign_b;
            end
        end

        // Handle zero result (always positive)
        if (mag_res == 0) sign_res = 0;

        // Overflow detection and saturation
        if (mag_res[N-2] && sign_res == 0) begin
            // Positive overflow
            res = {1'b0, {(N-1){1'b1}}};
        end else if (mag_res[N-2] && sign_res == 1) begin
            // Negative overflow
            res = {1'b1, {(N-1){1'b0}}};
        end else begin
            // Normal case
            res = {sign_res, mag_res};
        end

        // Assign final result with fractional precision
        c = res;
    end

endmodule