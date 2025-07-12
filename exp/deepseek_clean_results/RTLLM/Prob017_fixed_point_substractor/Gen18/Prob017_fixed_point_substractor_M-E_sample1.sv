module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Two's complement conversion
    wire [N-1:0] b_comp = ~b + 1'b1;
    
    // Parallel prefix adder implementation
    wire [N:0] carry_chain;
    wire [N-1:0] sum;
    wire [N-1:0] prop, gen;
    
    // Generate and propagate terms
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : prefix
            assign prop[i] = a[i] ^ b_comp[i];
            assign gen[i] = a[i] & b_comp[i];
        end
    endgenerate
    
    // Brent-Kung prefix tree
    assign carry_chain[0] = 1'b0;
    generate
        // First level: 1-bit spacing
        for (i = 0; i < N; i = i + 1) begin : level1
            assign carry_chain[i+1] = gen[i] | (prop[i] & carry_chain[i]);
        end
    endgenerate
    
    // Sum computation
    assign sum = prop ^ carry_chain[N-1:0];
    
    // Result selection and zero detection
    wire is_zero = ~(|sum);
    wire result_sign = sum[N-1] & ~is_zero;
    
    // Final result assembly
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} : {result_sign, sum[N-2:0]};

endmodule