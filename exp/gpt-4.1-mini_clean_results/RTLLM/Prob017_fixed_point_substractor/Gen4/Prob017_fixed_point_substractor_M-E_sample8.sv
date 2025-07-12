module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits (including sign)
    parameter integer Q = 8    // fractional bits (unused explicitly but defines format)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Separate sign and magnitude for inputs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Convert two's complement inputs to magnitude (unsigned)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Intermediate signals for result sign and magnitude
    reg result_sign;
    reg [N-1:0] result_mag;

    // Temporary variables for addition and subtraction of magnitudes
    wire [N:0] mag_sum = {1'b0, a_mag} + {1'b0, b_mag};          // N+1 bits to capture carry
    wire [N:0] mag_diff;

    // Magnitude subtraction with signed magnitude comparison
    // To avoid overflow, subtract smaller magnitude from larger
    wire a_mag_gt_b = (a_mag > b_mag);
    assign mag_diff = a_mag_gt_b ? ({1'b0,a_mag} - {1'b0,b_mag}) : ({1'b0,b_mag} - {1'b0,a_mag});

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: result sign = input signs
            result_sign = a_sign;

            // Subtract magnitudes
            if (a_mag >= b_mag)
                result_mag = a_mag - b_mag;
            else
                result_mag = b_mag - a_mag;
        end else begin
            // Different signs: add magnitudes and decide sign based on magnitude comparison
            result_mag = a_mag + b_mag;
            if (a_mag > b_mag)
                result_sign = a_sign;
            else if (b_mag > a_mag)
                result_sign = b_sign;
            else
                // Equal magnitudes => zero result, set sign 0
                result_sign = 1'b0;
        end

        // If result is zero, force sign bit to zero
        if (result_mag == 0)
            result_sign = 1'b0;
    end

    // Reconstruct two's complement output from sign and magnitude
    always @(*) begin
        if (result_sign == 1'b0) begin
            // Positive number or zero: direct magnitude
            c = result_mag;
        end else begin
            // Negative number: two's complement of magnitude
            c = ~result_mag + 1'b1;
        end
    end

endmodule