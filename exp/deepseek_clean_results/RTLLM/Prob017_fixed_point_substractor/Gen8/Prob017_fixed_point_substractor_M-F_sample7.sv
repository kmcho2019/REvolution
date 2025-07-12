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

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Magnitude calculation
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;
    wire [N-1:0] raw_diff = signs_equal ? (a - b) : (a_mag + b_mag);
    wire [N-2:0] magnitude = raw_diff[N-2:0];
    
    // Sign determination
    wire result_sign;
    assign result_sign = (raw_diff == 0) ? 1'b0 :          // Zero case
                         signs_equal    ? a_sign :          // Same signs
                         (a_mag > b_mag) ? a_sign : b_sign; // Different signs
    
    // Final output assignment
    assign c = {result_sign, magnitude};

endmodule