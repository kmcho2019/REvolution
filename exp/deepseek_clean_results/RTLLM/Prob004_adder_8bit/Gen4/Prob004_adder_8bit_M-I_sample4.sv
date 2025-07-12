module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate (G) and Propagate (P) signals
    wire [7:0] G = a & b;
    wire [7:0] P = a ^ b;
    
    // Carry computation (lookahead)
    wire [7:0] C;
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
                 (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | 
                 (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | 
                 (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | 
                 (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | 
                 (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                 (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | 
                 (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | 
                 (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                 (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                 (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    assign cout = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
                 (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);
    
    // Sum computation
    assign sum = P ^ {C[6:0], cin};

endmodule