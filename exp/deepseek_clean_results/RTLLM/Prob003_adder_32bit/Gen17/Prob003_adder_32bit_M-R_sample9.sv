module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and Propagate signals
    wire [32:1] G = A & B;
    wire [32:1] P = A ^ B;
    
    // Carry signals (grouped in 4-bit chunks)
    wire [8:0] C;
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Carry Lookahead Logic
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CLA_GROUP
            wire [3:0] G_group = G[i*4+4:i*4+1];
            wire [3:0] P_group = P[i*4+4:i*4+1];
            
            // Carry computation for each bit in group
            assign C[i+1] = G_group[3] |
                           (P_group[3] & G_group[2]) |
                           (P_group[3] & P_group[2] & G_group[1]) |
                           (P_group[3] & P_group[2] & P_group[1] & G_group[0]) |
                           (P_group[3] & P_group[2] & P_group[1] & P_group[0] & C[i]);
        end
    endgenerate
    
    // Sum calculation
    assign S = P ^ {C[8:1], C[0]};
    assign C32 = C[8];
endmodule