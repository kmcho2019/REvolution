module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    
    // Full-width addition with carry
    wire [N:0] full_sum = {1'b0, a} + {1'b0, b};
    
    // Full-width subtraction with borrow
    wire [N:0] full_diff = {1'b0, a} - {1'b0, b};
    
    // Result selection
    wire [N-1:0] res = (sign_a == sign_b) ? full_sum[N-1:0] : full_diff[N-1:0];
    
    // Overflow detection
    assign overflow = (sign_a == sign_b) ? 
                     (sign_a ? (full_sum[N] == 0) : (full_sum[N] == 1)) : 
                     1'b0;
    
    assign c = res;

endmodule