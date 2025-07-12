`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign
    parameter integer Q = 8    // fractional bits
)(
    input  wire [N-1:0] a,   // fixed-point two's complement input
    input  wire [N-1:0] b,   // fixed-point two's complement input
    output reg  [N-1:0] c    // fixed-point two's complement output
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Perform two's complement subtraction directly
    wire [N-1:0] sub_res = a - b;
    wire res_sign = sub_res[N-1];

    // Check zero result
    wire zero_res = (sub_res == {N{1'b0}});

    // Additional signals to check sign cases
    wire inputs_same_sign = (a_sign == b_sign);

    // Internal signal for adjusted result
    reg [N-1:0] adjusted_res;

    always @(*) begin
        // Start with direct subtraction result
        adjusted_res = sub_res;

        // Handle same sign subtraction case:
        // If inputs have same sign, result sign should match inputs'
        // If differs, adjust result sign by inverting magnitude and sign
        if (inputs_same_sign) begin
            if (a_sign != res_sign) begin
                // Result sign differs from inputs' sign - correct by magnitude recomputation
                // Compute magnitude of a and b
                // magnitude = abs(value) = (value[sign])? -value : value
                // We'll do magnitude subtraction and re-apply sign as input sign
                // magnitude_a and magnitude_b
                // But to keep code simple and hardware-friendly, just invert result sign and magnitude manually
                // Compute magnitude result as abs(sub_res)
                reg [N-1:0] mag_res;
                if (sub_res[N-1]) begin
                    mag_res = (~sub_res) + 1'b1; // abs by two's complement
                end else begin
                    mag_res = sub_res;
                end
                // Assign result with input sign and magnitude
                if (mag_res == {N{1'b0}}) begin
                    adjusted_res = {N{1'b0}}; // zero with sign zero
                end else if (a_sign) begin
                    // Negative result
                    adjusted_res = (~mag_res) + 1'b1;
                end else begin
                    // Positive result
                    adjusted_res = mag_res;
                end
            end
            // else result sign matches input sign, do nothing
        end else begin
            // Different sign subtraction interpreted as addition of magnitudes
            // Since we did a - b directly, we must confirm sign correctness based on magnitude comparison
            // Extract magnitudes
            reg [N-1:0] abs_a;
            reg [N-1:0] abs_b;
            if (a_sign) abs_a = (~a) + 1'b1; else abs_a = a;
            if (b_sign) abs_b = (~b) + 1'b1; else abs_b = b;

            reg [N-1:0] sum_mag;
            sum_mag = abs_a + abs_b;

            // Determine sign per problem spec:
            // a positive, b negative -> result sign positive if a_mag >= b_mag else negative
            // a negative, b positive -> result sign negative if |a| > b else positive
            reg expected_sign;
            if ((a_sign == 1'b0) && (b_sign == 1'b1)) begin
                // a positive, b negative
                expected_sign = (abs_a >= abs_b) ? 1'b0 : 1'b1;
            end else if ((a_sign == 1'b1) && (b_sign == 1'b0)) begin
                // a negative, b positive
                expected_sign = (abs_a > abs_b) ? 1'b1 : 1'b0;
            end else begin
                expected_sign = 1'b0; // default, should not happen here
            end

            // Construct adjusted result from sum_mag and expected sign
            if (sum_mag == {N{1'b0}}) begin
                adjusted_res = {N{1'b0}};
            end else if (expected_sign) begin
                adjusted_res = (~sum_mag) + 1'b1;
            end else begin
                adjusted_res = sum_mag;
            end
        end

        // Explicitly clear sign bit if result is zero
        if (adjusted_res == {N{1'b0}}) begin
            adjusted_res = {1'b0, {(N-1){1'b0}}};
        end
    end

    // Register output (could be combinational if preferred)
    always @(*) begin
        c = adjusted_res;
    end

endmodule