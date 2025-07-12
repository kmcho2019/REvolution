module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Propagate and Generate signals
    wire [7:0] P, G;
    assign P = a ^ b;
    assign G = a & b;

    // Carry lookahead logic
    wire c0, c1, c2, c3, c4, c5, c6;
    
    // Bit 0
    assign c0 = G[0] | (P[0] & cin);
    assign sum[0] = P[0] ^ cin;
    
    // Bit 1
    assign c1 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign sum[1] = P[1] ^ c0;
    
    // Bit 2
    assign c2 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | 
                (P[2] & P[1] & P[0] & cin);
    assign sum[2] = P[2] ^ c1;
    
    // Bit 3
    assign c3 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
                (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);
    assign sum[3] = P[3] ^ c2;
    
    // Bit 4
    assign c4 = G[4] | (P[4] & c3);
    assign sum[4] = P[4] ^ c3;
    
    // Bit 5
    assign c5 = G[5] | (P[5] & G[4]) | (P[5] & P[4] & c3);
    assign sum[5] = P[5] ^ c4;
    
    // Bit 6
    assign c6 = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | 
                (P[6] & P[5] & P[4] & c3);
    assign sum[6] = P[6] ^ c5;
    
    // Bit 7
    assign cout = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
                 (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & c3);
    assign sum[7] = P[7] ^ c6;

endmodule