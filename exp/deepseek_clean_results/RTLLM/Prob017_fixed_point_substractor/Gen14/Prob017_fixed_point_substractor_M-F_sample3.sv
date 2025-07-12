module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    generate
        if (Q >= N) begin
            initial $error("Fractional bits Q must be less than total bits N");
        end
    endgenerate

    // Zero detection
    wire is_zero = (a == b);

    // Magnitude calculation
    wire [N-2:0] abs_a = a[N-1] ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] abs_b = b[N-1] ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    wire [N-2:0] mag_diff = (abs_a > abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);

    // Sign determination
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire same_sign = ~(a_sign ^ b_sign);
    wire a_larger_mag = (abs_a > abs_b);
    
    wire result_sign = is_zero ? 1'b0 :
                     same_sign ? a_sign :
                     (a_sign ? ~a_larger_mag : a_larger_mag);

    // Result assembly
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} :
              {result_sign, mag_diff};

endmodule