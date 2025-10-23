module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Subtraction: result = A - B = A + (~B) + 1
    wire [63:0] B_neg = ~B;
    wire cin = 1'b1;

    // Generate propagate and generate signals for each bit
    wire [63:0] P = A ^ B_neg;  // propagate = A xor B_neg
    wire [63:0] G = A & B_neg;  // generate  = A and B_neg

    // Carry signals C[i]: carry into bit i
    // C[0] = cin
    wire [64:0] C;
    assign C[0] = cin;

    // Implement a parallel prefix carry-lookahead tree for 64 bits
    // Use Brent-Kung style prefix structure for reasonable area and speed

    // First level: pairs (2-bit groups)
    wire [63:0] G1, P1;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : initial_gp
            G1[i] = G[i];
            P1[i] = P[i];
        end
    endgenerate

    // Define a prefix operator for (G,P)
    // prefix_op: (Gk,Pk) and (Gj,Pj) -> (Gout, Pout)
    // Gout = Gk | (Pk & Gj)
    // Pout = Pk & Pj
    function automatic [1:0] prefix_op;
        input [1:0] left;   // {Gk, Pk}
        input [1:0] right;  // {Gj, Pj}
        reg G_out, P_out;
        begin
            G_out = left[1] | (left[0] & right[1]);
            P_out = left[0] & right[0];
            prefix_op = {G_out, P_out};
        end
    endfunction

    // We'll implement a Brent-Kung parallel prefix network to compute carries
    // Using generate and propagate pairs: {G,P} stored as bits [G,P]

    // Stage 0: initial G1,P1 already assigned

    // For indexing convenience:
    // We'll store intermediate G,P signals per stage in arrays:
    // Stage 0: gp[0][i] = {G1[i], P1[i]}
    // Subsequent stages will compute gp[s][i] by combining pairs

    // Since 64 bits, max stages = log2(64) = 6
    // We'll create a generate loop for stages

    wire [1:0] gp_stage [0:6][63:0]; // [stage][bit] = {G,P}

    // Initialize stage 0
    generate
        for (i = 0; i < 64; i = i + 1) begin : init_gp
            assign gp_stage[0][i] = {G1[i], P1[i]};
        end
    endgenerate

    // Prefix computation for stages 1 to 6
    // At stage s (1 to 6), combine pairs separated by 2^{s-1} bits
    genvar s, j;
    generate
        for (s = 1; s <= 6; s = s + 1) begin : stages
            for (j = 0; j < 64; j = j + 1) begin : bits
                if (j < (1 << (s - 1))) begin
                    // bits with index less than 2^{s-1} just pass previous stage through
                    assign gp_stage[s][j] = gp_stage[s-1][j];
                end else begin
                    // combine gp_stage[s-1][j] and gp_stage[s-1][j - 2^{s-1}]
                    wire [1:0] left  = gp_stage[s-1][j];
                    wire [1:0] right = gp_stage[s-1][j - (1 << (s -1))];
                    assign gp_stage[s][j] = prefix_op(left, right);
                end
            end
        end
    endgenerate

    // After stage 6, gp_stage[6][i] contains combined G,P up to bit i

    // Compute carries C[i] = G_{i-1:0} + propagate chain
    // Carry into bit 0 = cin = 1
    // Carry into bit i = G_prefix(i-1) | (P_prefix(i-1) & cin)
    // From prefix tree, gp_stage[6][i-1] = {G_prefix(i-1), P_prefix(i-1)}

    generate
        for (i = 1; i <= 64; i = i + 1) begin : assign_carry
            // for i=1..64:
            // C[i] = G_prefix(i-1) | (P_prefix(i-1) & C[0])
            assign C[i] = gp_stage[6][i-1][1] | (gp_stage[6][i-1][0] & C[0]);
        end
    endgenerate

    // Result bits = P[i] xor C[i]
    // Because sum_i = propagate_i xor carry_in_i
    assign result = P ^ C[63:0];

    // Overflow detection
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule