module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Group signals into 4-bit blocks (8 blocks total)
    wire [7:0] G_block, P_block;
    wire [7:0] C_block;
    
    // Generate 8x 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            // Calculate block generate and propagate
            wire [3:0] G_bit = A[i*4+4:i*4+1] & B[i*4+4:i*4+1];
            wire [3:0] P_bit = A[i*4+4:i*4+1] ^ B[i*4+4:i*4+1];
            
            // Block generate/propagate
            assign G_block[i] = G_bit[3] | 
                              (P_bit[3] & G_bit[2]) | 
                              (P_bit[3] & P_bit[2] & G_bit[1]) | 
                              (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
            assign P_block[i] = P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0];
            
            // Calculate sum bits
            wire [3:0] C_internal;
            assign C_internal[0] = (i == 0) ? 1'b0 : C_block[i-1];
            assign C_internal[1] = G_bit[0] | (P_bit[0] & C_internal[0]);
            assign C_internal[2] = G_bit[1] | (P_bit[1] & G_bit[0]) | (P_bit[1] & P_bit[0] & C_internal[0]);
            assign C_internal[3] = G_bit[2] | (P_bit[2] & G_bit[1]) | (P_bit[2] & P_bit[1] & G_bit[0]) | 
                                 (P_bit[2] & P_bit[1] & P_bit[0] & C_internal[0]);
            
            assign S[i*4+4:i*4+1] = P_bit ^ {C_internal[2:0], C_internal[0]};
        end
    endgenerate
    
    // Carry lookahead between blocks (parallel prefix computation)
    assign C_block[0] = G_block[0] | (P_block[0] & 1'b0);
    assign C_block[1] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & 1'b0);
    assign C_block[2] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0]) | 
                       (P_block[2] & P_block[1] & P_block[0] & 1'b0);
    assign C_block[3] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | 
                       (P_block[3] & P_block[2] & P_block[1] & G_block[0]) | 
                       (P_block[3] & P_block[2] & P_block[1] & P_block[0] & 1'b0);
    
    // Second level carry lookahead
    wire [3:0] G_group, P_group;
    assign G_group[0] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | 
                       (P_block[3] & P_block[2] & P_block[1] & G_block[0]);
    assign P_group[0] = P_block[3] & P_block[2] & P_block[1] & P_block[0];
    
    assign C_block[4] = G_block[4] | (P_block[4] & G_group[0]);
    assign C_block[5] = G_block[5] | (P_block[5] & G_block[4]) | (P_block[5] & P_block[4] & G_group[0]);
    assign C_block[6] = G_block[6] | (P_block[6] & G_block[5]) | (P_block[6] & P_block[5] & G_block[4]) | 
                       (P_block[6] & P_block[5] & P_block[4] & G_group[0]);
    assign C_block[7] = G_block[7] | (P_block[7] & G_block[6]) | (P_block[7] & P_block[6] & G_block[5]) | 
                       (P_block[7] & P_block[6] & P_block[5] & G_block[4]) | 
                       (P_block[7] & P_block[6] & P_block[5] & P_block[4] & G_group[0]);
    
    assign C32 = C_block[7];
endmodule