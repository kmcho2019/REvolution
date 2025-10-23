module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Magnitude comparison (unsigned)
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);
    wire mag_equal = (a[N-2:0] == b[N-2:0]);

    // Operation selection
    wire do_add = (sign_a == sign_b);
    
    // Optimized arithmetic paths
    wire [N-1:0] mag_result;
    if (do_add) begin
        // Direct addition when signs match
        mag_result = a + b;
    end else begin
        // Subtraction path
        mag_result = a_gt_b ? (a - b) : (b - a);
    end

    // Result sign determination
    wire res_sign = do_add ? sign_a : 
                   (a_gt_b ? sign_a : 
                   (mag_equal ? 1'b0 : sign_b));

    // Overflow detection (only for addition case)
    wire overflow = do_add && (mag_result[N-1] != sign_a);

    // Final output with overflow saturation
    assign c = overflow ? 
               {sign_a, {(N-1){~sign_a}}} :  // Saturate to max positive or min negative
               {res_sign, mag_result[N-2:0]}; // Maintain correct sign

endmodule