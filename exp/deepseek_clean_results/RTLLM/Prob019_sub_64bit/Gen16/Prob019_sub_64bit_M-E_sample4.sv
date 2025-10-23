module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Two's complement of B (computed in parallel)
    wire [63:0] B_comp = ~B;
    wire [63:0] B_twos = B_comp + 1;

    // Hierarchical prefix tree parameters
    localparam P_LEVELS = 6; // log2(64)
    
    // Propagate/Generate signals
    wire [63:0] p = A ^ B_twos;
    wire [63:0] g = A & B_twos;
    
    // Prefix tree wires
    wire [63:0][P_LEVELS-1:0] pp, gg;
    
    // First level (bitwise)
    assign pp[0][0] = p[0];
    assign gg[0][0] = g[0];
    generate
        for (genvar i = 1; i < 64; i++) begin : bit_prop
            assign pp[i][0] = p[i];
            assign gg[i][0] = g[i];
        end
    endgenerate
    
    // Prefix tree construction (hybrid Kogge-Stone/Brent-Kung)
    generate
        for (genvar l = 1; l < P_LEVELS; l++) begin : level_gen
            for (genvar i = 0; i < 64; i++) begin : bit_gen
                if (i >= (1<<(l-1))) begin
                    assign pp[i][l] = pp[i][l-1] & pp[i-(1<<(l-1))][l-1];
                    assign gg[i][l] = gg[i][l-1] | (pp[i][l-1] & gg[i-(1<<(l-1))][l-1]);
                end else begin
                    assign pp[i][l] = pp[i][l-1];
                    assign gg[i][l] = gg[i][l-1];
                end
            end
        end
    endgenerate
    
    // Carry computation
    wire [63:0] carry;
    assign carry[0] = 0; // No carry-in
    generate
        for (genvar i = 1; i < 64; i++) begin : carry_gen
            assign carry[i] = gg[i-1][P_LEVELS-1];
        end
    endgenerate
    
    // Result computation
    assign result = p ^ {carry[62:0], 1'b0};
    
    // Early overflow detection (speculative)
    wire msb_p = pp[63][P_LEVELS-1];
    wire msb_g = gg[63][P_LEVELS-1];
    wire predicted_overflow = (A[63] != B[63]) && 
                             ((msb_g || (msb_p && carry[63])) ^ A[63]);
    
    // Final overflow determination
    always_comb begin
        // Use early prediction if valid, otherwise fall back to exact check
        overflow = predicted_overflow ? 1'b1 : 
                  (A[63] != B[63]) && (A[63] != result[63]);
    end

    // Alternative fast path for obvious overflow cases
    wire extreme_overflow = (A == 64'h8000000000000000) && (B == 64'h7FFFFFFFFFFFFFFF);
    always_comb begin
        if (extreme_overflow) overflow = 1'b1;
    end

endmodule