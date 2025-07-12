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

    // Magnitude comparison (unsigned)
    wire a_gt_b = (a[N-2:0] > b[N-2:0]);

    // Parallel subtraction operations
    wire [N-2:0] a_minus_b = a[N-2:0] - b[N-2:0];
    wire [N-2:0] b_minus_a = b[N-2:0] - a[N-2:0];

    // Sign prediction
    wire sign_a_minus_b = a[N-1] ^ b[N-1] ? a[N-1] : (a[N-1] ^ (a_minus_b[N-2] & |a_minus_b));
    wire sign_b_minus_a = a[N-1] ^ b[N-1] ? b[N-1] : (b[N-1] ^ (b_minus_a[N-2] & |b_minus_a));

    // Result selection
    wire [N-1:0] result = is_zero ? {1'b0, {(N-1){1'b0}}} :
                         (a_gt_b ? {sign_a_minus_b, a_minus_b} : 
                                  {sign_b_minus_a, b_minus_a});

    assign c = result;

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Fractional bits Q must be less than total bits N");
        end
    end

endmodule