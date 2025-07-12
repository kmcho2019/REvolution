module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and Propagate signals for each bit
    wire [32:1] G = A & B;
    wire [32:1] P = A ^ B;
    
    // Carry signals for each 4-bit block (8 blocks total)
    wire [8:0] carry;
    assign carry[0] = 1'b0;  // Initial carry-in
    
    // Generate carries for each 4-bit block
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            wire [3:0] block_G = G[i*4+4:i*4+1];
            wire [3:0] block_P = P[i*4+4:i*4+1];
            
            // Carry lookahead logic for this block
            wire G_block = block_G[3] | 
                          (block_P[3] & block_G[2]) | 
                          (block_P[3] & block_P[2] & block_G[1]) | 
                          (block_P[3] & block_P[2] & block_P[1] & block_G[0]);
            
            wire P_block = block_P[3] & block_P[2] & block_P[1] & block_P[0];
            
            // Block carry out
            assign carry[i+1] = G_block | (P_block & carry[i]);
        end
    endgenerate
    
    // Compute sums for each bit
    assign S[1] = P[1] ^ carry[0];
    assign S[2] = P[2] ^ (G[1] | (P[1] & carry[0]));
    assign S[3] = P[3] ^ (G[2] | (P[2] & G[1]) | (P[2] & P[1] & carry[0]));
    
    generate
        for (i = 4; i <= 32; i = i + 1) begin : sum_gen
            // Carry for current bit
            wire c_bit;
            if (i % 4 == 1) begin
                assign c_bit = carry[i/4];
            end else begin
                localparam block = i/4;
                localparam pos = i%4 - 1;
                assign c_bit = G[i-1] | 
                              (P[i-1] & G[i-2]) | 
                              (P[i-1] & P[i-2] & G[i-3]) | 
                              (P[i-1] & P[i-2] & P[i-3] & carry[block]);
            end
            assign S[i] = P[i] ^ c_bit;
        end
    endgenerate
    
    assign C32 = carry[8];
endmodule