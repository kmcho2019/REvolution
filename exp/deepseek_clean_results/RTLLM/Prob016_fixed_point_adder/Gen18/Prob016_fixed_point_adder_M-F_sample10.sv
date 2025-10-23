module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Fractional bits Q (%0d) must be less than total bits N (%0d)", Q, N);
        end
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Operation selection
    wire do_add = (a_sign == b_sign);
    
    // Magnitude operations
    wire [N-1:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};
    wire a_gt_b = (a_mag > b_mag);
    wire [N-1:0] diff_mag = a_gt_b ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};

    // Result sign determination
    wire res_sign = do_add ? a_sign : 
                   (a_gt_b ? a_sign : b_sign);

    // Result magnitude selection
    wire [N-1:0] res_mag = do_add ? sum_mag : diff_mag;

    // Simplified overflow detection (check MSB only)
    wire overflow = do_add & sum_mag[N-1];

    // Final result construction with saturation
    assign c = overflow ? 
              {a_sign, {(N-1){~a_sign}}} :  // Saturate to max/min
              {res_sign, res_mag[N-2:0]};   // Normal result

endmodule