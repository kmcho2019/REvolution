module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using generate
    generate
        if (N <= Q) begin
            initial $error("N must be greater than Q");
        end
        if (Q <= 0) begin
            initial $error("Q must be positive");
        end
    endgenerate

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude calculations (absolute values)
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;
    
    // Determine if signs are equal
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Calculate raw difference
    wire [N-1:0] raw_diff = signs_equal ? (a - b) : (a_mag + b_mag);
    
    // Special case: zero result
    wire is_zero = (raw_diff == 0);
    
    // Result sign determination
    wire result_sign;
    assign result_sign = is_zero ? 1'b0 :
                        signs_equal ? a_sign :
                        (a_mag > b_mag) ? a_sign : b_sign;
    
    // Final output assignment
    assign c = {result_sign, raw_diff[N-2:0]};

endmodule