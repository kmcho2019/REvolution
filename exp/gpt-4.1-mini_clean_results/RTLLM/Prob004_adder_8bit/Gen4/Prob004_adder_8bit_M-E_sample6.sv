module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);

    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [7:0] c; // carry signals, c[-1] = cin internally

    // Step 1: compute bit propagate and generate
    assign p = a ^ b;   // propagate = a XOR b
    assign g = a & b;   // generate  = a AND b

    // Step 2: carry generation using hierarchical prefix logic
    // Define internal group generate/propagate signals at different levels

    // Level 1: Combine pairs of bits (2-bit groups)
    wire [3:0] g1, p1;
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : level1
            // group generate for bits 2i+1:2i
            // G = g_hi | (p_hi & g_lo)
            assign g1[i] = g[2*i+1] | (p[2*i+1] & g[2*i]);
            // group propagate for bits 2i+1:2i
            assign p1[i] = p[2*i+1] & p[2*i];
        end
    endgenerate

    // Level 2: Combine 4-bit groups (2 pairs from level 1)
    wire [1:0] g2, p2;
    generate
        for (i=0; i<2; i=i+1) begin : level2
            // group generate for bits 4i+3:4i
            assign g2[i] = g1[2*i+1] | (p1[2*i+1] & g1[2*i]);
            assign p2[i] = p1[2*i+1] & p1[2*i];
        end
    endgenerate

    // Level 3: Combine entire 8-bit group (bits 7:0)
    wire g3, p3;
    assign g3 = g2[1] | (p2[1] & g2[0]);
    assign p3 = p2[1] & p2[0];

    // Step 3: compute carry-ins c[0..7]
    // carry in at bit -1 is cin
    // Carry at bit 0:
    assign c[0] = g[0] | (p[0] & cin);

    // Carry at bit 1:
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);

    // Carry at bit 2:
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);

    // Carry at bit 3:
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

    // Carry at bit 4:
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) |
                  (p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[4] & p[3] & p[2] & p[1] & p[0] & cin);

    // Carry at bit 5:
    assign c[5] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) |
                  (p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

    // Carry at bit 6:
    assign c[6] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) |
                  (p[6] & p[5] & p[4] & p[3] & g[2]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

    // Carry at bit 7:
    assign c[7] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) |
                  (p[7] & p[6] & p[5] & p[4] & g[3]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

    // Step 4: sum bits = p[i] XOR c[i-1], with c[-1] = cin
    assign sum[0] = p[0] ^ cin;
    generate
        for (i=1; i<8; i=i+1) begin : sum_bits
            assign sum[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Final carry out = c[7]
    assign cout = c[7];

endmodule