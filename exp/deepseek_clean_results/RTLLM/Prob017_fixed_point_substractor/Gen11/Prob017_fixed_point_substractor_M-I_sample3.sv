module fixed_point_subtractor #(
    parameter TOTAL_BITS = 32,    // Total number of bits (N)
    parameter FRAC_BITS = 16      // Number of fractional bits (Q)
) (
    input wire [TOTAL_BITS-1:0] a,
    input wire [TOTAL_BITS-1:0] b,
    output wire [TOTAL_BITS-1:0] c
);

    // Parameter validation
    initial begin
        if (FRAC_BITS >= TOTAL_BITS) begin
            $error("Fractional bits (Q) must be less than total bits (N)");
        end
    end

    localparam MAG_BITS = TOTAL_BITS - 1;  // Magnitude bits

    // Sign extraction
    wire a_sign = a[TOTAL_BITS-1];
    wire b_sign = b[TOTAL_BITS-1];

    // Direct subtraction when signs match
    wire [MAG_BITS:0] full_diff = {1'b0, a[MAG_BITS-1:0]} - {1'b0, b[MAG_BITS-1:0]};
    wire diff_sign = full_diff[MAG_BITS];
    wire is_zero = (full_diff[MAG_BITS-1:0] == 0);

    // Sign determination
    wire signs_match = (a_sign == b_sign);
    wire result_sign = is_zero ? 1'b0 : 
                      (signs_match ? (a_sign ^ diff_sign) : a_sign);

    // Magnitude selection
    wire [MAG_BITS-1:0] result_mag;
    if (signs_match) begin
        assign result_mag = diff_sign ? (~full_diff[MAG_BITS-1:0] + 1) : 
                                       full_diff[MAG_BITS-1:0];
    end
    else begin
        assign result_mag = full_diff[MAG_BITS-1:0];
    end

    // Final result assembly
    assign c = is_zero ? {1'b0, {MAG_BITS{1'b0}}} : 
               {result_sign, result_mag};

endmodule