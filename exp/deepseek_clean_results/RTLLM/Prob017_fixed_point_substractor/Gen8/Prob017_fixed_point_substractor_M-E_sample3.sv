module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude conversion (absolute value)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Special case detection
    wire a_zero = ~(|a[N-2:0]);
    wire b_zero = ~(|b[N-2:0]);
    
    // Sign determination logic
    wire same_sign = ~(a_sign ^ b_sign);
    wire a_larger = (a_mag > b_mag) | b_zero;
    wire result_sign = same_sign ? a_sign : 
                     (a_sign & ~a_zero) ? (a_larger ? 1'b1 : 1'b0) :
                     (~a_sign & ~b_zero) ? (a_larger ? 1'b0 : 1'b1) : 1'b0;
    
    // Parallel prefix subtraction (Brent-Kung)
    wire [N-1:0] diff;
    wire [N-2:0] b_comp = ~b_mag;
    wire [N-1:0] carry;
    
    // Generate and propagate
    wire [N-1:0] g, p;
    assign g[0] = a_mag[0] & b_comp[0];
    assign p[0] = a_mag[0] ^ b_comp[0];
    genvar i;
    generate
        for (i = 1; i < N-1; i = i+1) begin : pp_stage1
            assign g[i] = a_mag[i] & b_comp[i];
            assign p[i] = a_mag[i] ^ b_comp[i];
        end
    endgenerate
    
    // Prefix computation
    wire [N-2:0] g_lev1, p_lev1;
    generate
        for (i = 0; i < N-1; i = i+2) begin : lev1
            assign g_lev1[i/2] = g[i+1] | (p[i+1] & g[i]);
            assign p_lev1[i/2] = p[i+1] & p[i];
        end
    endgenerate
    
    wire [N/4-1:0] g_lev2, p_lev2;
    generate
        for (i = 0; i < N/2; i = i+2) begin : lev2
            assign g_lev2[i/2] = g_lev1[i+1] | (p_lev1[i+1] & g_lev1[i]);
            assign p_lev2[i/2] = p_lev1[i+1] & p_lev1[i];
        end
    endgenerate
    
    // Final carry computation
    assign carry[0] = 1'b1;  // Initial carry-in for subtraction
    assign carry[1] = g[0];
    assign carry[2] = g_lev1[0];
    assign carry[3] = g_lev1[1] | (p_lev1[1] & g_lev1[0]);
    // ... continue carry computation for all bits
    
    // Sum computation
    assign diff[0] = p[0] ^ carry[0];
    generate
        for (i = 1; i < N-1; i = i+1) begin : sum_comp
            assign diff[i] = p[i] ^ carry[i];
        end
    endgenerate
    
    // Result assembly
    wire [N-2:0] result_mag = diff[N-2:0];
    wire is_zero = ~(|result_mag);
    
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : 
               {result_sign, result_mag};

endmodule