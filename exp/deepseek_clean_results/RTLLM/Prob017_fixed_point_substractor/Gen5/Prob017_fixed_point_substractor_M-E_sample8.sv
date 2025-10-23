module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire eq = (a_mag == b_mag);

    // Absolute value subtraction
    wire [N-2:0] abs_diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);

    // Sign determination logic
    reg result_sign;
    always @(*) begin
        if (eq) begin
            result_sign = 1'b0;  // Force positive zero
        end
        else if (a_sign == b_sign) begin
            result_sign = a_sign ^ (a_gt_b ? 1'b0 : 1'b1);
        end
        else begin
            result_sign = a_sign;
        end
    end

    // Final result assembly
    assign c = {result_sign, abs_diff};

endmodule