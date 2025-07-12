module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Early zero detection
    wire is_zero = (a == b);

    // Magnitude difference (unsigned)
    wire [N-2:0] mag_diff = (a[N-2:0] > b[N-2:0]) ? 
                           (a[N-2:0] - b[N-2:0]) : 
                           (b[N-2:0] - a[N-2:0]);

    // Sign determination
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);
    wire same_sign = ~(a[N-1] ^ b[N-1]);
    
    wire result_sign = is_zero ? 1'b0 :
                     same_sign ? a[N-1] :
                     (a[N-1] ? ~a_gt_b : a_gt_b);

    // Final result assembly
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} :
              {result_sign, mag_diff};

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Fractional bits Q must be less than total bits N");
        end
    end

endmodule