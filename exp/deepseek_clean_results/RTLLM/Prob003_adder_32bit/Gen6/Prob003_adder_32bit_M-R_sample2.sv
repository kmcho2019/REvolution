module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Internal carry signals between 4-bit blocks
    wire [7:0] carry;
    
    // Generate 8 instances of 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            wire [3:0] G = A[(i*4)+4 : (i*4)+1] & B[(i*4)+4 : (i*4)+1];
            wire [3:0] P = A[(i*4)+4 : (i*4)+1] ^ B[(i*4)+4 : (i*4)+1];
            wire [3:0] C;
            
            // First block gets carry-in = 0
            if (i == 0) begin
                assign C[0] = 1'b0;
            end else begin
                assign C[0] = carry[i-1];
            end
            
            // Carry lookahead within 4-bit block
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & C[1]);
            assign C[3] = G[2] | (P[2] & C[2]);
            assign carry[i] = G[3] | (P[3] & C[3]);
            
            // Sum computation
            assign S[(i*4)+4 : (i*4)+1] = P ^ C;
        end
    endgenerate
    
    // Final carry out
    assign C32 = carry[7];
endmodule