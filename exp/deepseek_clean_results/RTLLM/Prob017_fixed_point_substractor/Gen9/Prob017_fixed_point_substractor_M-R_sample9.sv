module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (N <= Q) $error("N must be greater than Q");
        if (Q <= 0) $error("Q must be positive");
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude calculations
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;
    
    // Sign comparison
    wire signs_equal = (a_sign == b_sign);
    
    // Arithmetic operation selection
    wire [N-1:0] raw_diff = signs_equal ? (a - b) : (a_mag + b_mag);
    
    // Result components
    wire [N-2:0] magnitude = raw_diff[N-2:0];
    wire is_zero = (raw_diff == 0);
    
    // Sign determination
    wire sign_same_case = a_sign;
    wire sign_diff_case = (a_mag > b_mag) ? a_sign : b_sign;
    wire result_sign = is_zero ? 1'b0 : 
                      (signs_equal ? sign_same_case : sign_diff_case);
    
    // Final output
    assign c = {result_sign, magnitude};

endmodule