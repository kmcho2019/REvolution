module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Stage 1: Generate and Propagate
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Stage 2: First level prefix computation (4-bit groups)
    wire [7:0] g1, p1;
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : prefix
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate
    
    // Stage 3: Second level prefix computation (final carries)
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = g1[1];
    assign c[2] = g1[2] | (p1[2] & g1[0]);
    assign c[3] = g1[3] | (p1[3] & g1[1]);
    assign c[4] = g1[4] | (p1[4] & g1[2]);
    assign c[5] = g1[5] | (p1[5] & g1[3]);
    assign c[6] = g1[6] | (p1[6] & g1[4]);
    assign c[7] = g1[7] | (p1[7] & g1[5]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Early overflow detection (computed in parallel with sum)
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = s[7];
    wire carry_in = c[6];
    wire carry_out = c[7];
    
    assign overflow = (~(sign_a ^ sign_b)) & (sign_a ^ sign_sum);
endmodule