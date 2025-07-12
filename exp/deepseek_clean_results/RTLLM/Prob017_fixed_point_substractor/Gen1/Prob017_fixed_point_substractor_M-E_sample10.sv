module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] raw_diff;
    wire overflow_pos, overflow_neg;
    wire sign_a, sign_b, sign_diff;

    // Direct subtraction
    assign raw_diff = a - b;

    // Sign bits
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];
    assign sign_diff = raw_diff[N-1];

    // Overflow detection
    assign overflow_pos = (~sign_a & sign_b & sign_diff);  // a+ - b- = should be +
    assign overflow_neg = (sign_a & ~sign_b & ~sign_diff); // a- - b+ = should be -

    always @(*) begin
        // Default case - no overflow
        c = raw_diff;

        // Handle overflow cases
        if (overflow_pos) begin
            c = {1'b0, {(N-1){1'b1}}};  // Saturate to max positive
        end
        else if (overflow_neg) begin
            c = {1'b1, {(N-1){1'b0}}};  // Saturate to max negative
        end

        // Explicit zero handling
        if (raw_diff == 0) begin
            c = 0;
        end
    end

endmodule