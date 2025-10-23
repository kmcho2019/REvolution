module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output G_group,
    output P_group
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    // First level carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    
    // Group propagate/generate
    assign G_group = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
                    (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
                    (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
    assign P_group = &P;
    
    assign Cout = G[7] | (P[7] & C[7]);
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G_8bit;
    wire [3:0] P_8bit;
    wire [3:0] carry_8bit;
    
    // Generate 4x 8-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_blocks
            cla_8bit cla (
                .A(A[(i*8)+8 : (i*8)+1]),
                .B(B[(i*8)+8 : (i*8)+1]),
                .Cin(i == 0 ? 1'b0 : carry_8bit[i-1]),
                .S(S[(i*8)+8 : (i*8)+1]),
                .Cout(carry_8bit[i]),
                .G_group(G_8bit[i]),
                .P_group(P_8bit[i])
            );
        end
    endgenerate
    
    // Second level carry lookahead
    wire [3:0] C_high;
    assign C_high[0] = 1'b0;
    assign C_high[1] = G_8bit[0] | (P_8bit[0] & C_high[0]);
    assign C_high[2] = G_8bit[1] | (P_8bit[1] & C_high[1]);
    assign C_high[3] = G_8bit[2] | (P_8bit[2] & C_high[2]);
    assign C32 = G_8bit[3] | (P_8bit[3] & C_high[3]);
    
    // Correct the intermediate carries using second-level lookahead
    assign carry_8bit[0] = G_8bit[0] | (P_8bit[0] & 1'b0);
    assign carry_8bit[1] = G_8bit[1] | (P_8bit[1] & carry_8bit[0]);
    assign carry_8bit[2] = G_8bit[2] | (P_8bit[2] & carry_8bit[1]);
endmodule