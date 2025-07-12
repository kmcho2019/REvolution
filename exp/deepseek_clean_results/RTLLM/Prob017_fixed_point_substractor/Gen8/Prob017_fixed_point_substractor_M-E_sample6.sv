module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Early zero detection
    wire inputs_equal = (a == b);
    
    // Sign comparison
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_differ = a_sign ^ b_sign;
    
    // Magnitude comparison (unsigned)
    wire [N-1:0] abs_a = a_sign ? -a : a;
    wire [N-1:0] abs_b = b_sign ? -b : b;
    wire a_larger = (abs_a > abs_b);
    
    // Parallel computation paths
    wire signed [N-1:0] same_sign_result = a - b;
    wire signed [N-1:0] diff_sign_result;
    
    assign diff_sign_result = a_sign ? 
                           (a_larger ? -(abs_a - abs_b) : (abs_b - abs_a)) :
                           (a_larger ? (abs_a - abs_b) : -(abs_b - abs_a));
    
    // Result selection
    always @(*) begin
        if (inputs_equal) begin
            c = 0;  // Early zero handling
        end else begin
            c = signs_differ ? diff_sign_result : same_sign_result;
        end
    end

endmodule