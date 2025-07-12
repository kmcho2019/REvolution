module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Two's complement subtraction: a - b = a + (~b + 1)
    wire [N-1:0] b_comp = ~b + 1'b1;
    
    // Ripple-carry addition
    wire [N:0] carry;
    wire [N-1:0] sum;
    
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b_comp[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_comp[i]) | 
                               ((a[i] ^ b_comp[i]) & carry[i]);
        end
    endgenerate
    
    // Overflow detection (for information, not used in result)
    wire overflow = carry[N] ^ carry[N-1];
    
    // Zero detection with reduction OR
    wire is_zero = ~(|sum);
    
    // Final result assignment
    assign c = is_zero ? {N{1'b0}} : sum;

endmodule