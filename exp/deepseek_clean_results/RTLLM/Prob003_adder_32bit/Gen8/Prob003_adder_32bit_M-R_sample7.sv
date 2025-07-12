module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and Propagate terms for each bit
    wire [32:1] G = A & B;
    wire [32:1] P = A ^ B;
    
    // Carry signals
    wire [32:0] C;
    assign C[0] = 1'b0;  // Carry-in
    
    // First level lookahead (4-bit groups)
    wire [7:0] GG, PG;  // Group Generate/Propagate
    wire [7:0] GC;      // Group Carry
    
    // Generate 4-bit group lookahead terms
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : GROUP_LOOKAHEAD
            localparam [3:0] idx = i * 4;
            assign GG[i] = G[idx+4] | (P[idx+4] & G[idx+3]) | 
                          (P[idx+4] & P[idx+3] & G[idx+2]) | 
                          (P[idx+4] & P[idx+3] & P[idx+2] & G[idx+1]);
            assign PG[i] = P[idx+4] & P[idx+3] & P[idx+2] & P[idx+1];
        end
    endgenerate
    
    // Second level lookahead (16-bit blocks)
    wire [1:0] GGG, PGG;  // Super-group Generate/Propagate
    assign GGG[0] = GG[3] | (PG[3] & GG[2]) | (PG[3] & PG[2] & GG[1]) | (PG[3] & PG[2] & PG[1] & GG[0]);
    assign PGG[0] = PG[3] & PG[2] & PG[1] & PG[0];
    assign GGG[1] = GG[7] | (PG[7] & GG[6]) | (PG[7] & PG[6] & GG[5]) | (PG[7] & PG[6] & PG[5] & GG[4]);
    assign PGG[1] = PG[7] & PG[6] & PG[5] & PG[4];
    
    // Generate final carries
    assign GC[0] = GG[0] | (PG[0] & C[0]);
    assign GC[1] = GG[1] | (PG[1] & GC[0]);
    assign GC[2] = GG[2] | (PG[2] & GC[1]);
    assign GC[3] = GG[3] | (PG[3] & GC[2]);
    
    assign GC[4] = GG[4] | (PG[4] & GGG[0]);
    assign GC[5] = GG[5] | (PG[5] & GC[4]);
    assign GC[6] = GG[6] | (PG[6] & GC[5]);
    assign GC[7] = GG[7] | (PG[7] & GC[6]);
    
    // Generate individual bit carries
    generate
        for (i = 1; i <= 32; i = i + 1) begin : BIT_CARRY
            localparam group = (i-1)/4;
            localparam in_group = (i-1)%4;
            
            if (in_group == 0) begin
                assign C[i] = GC[group];
            end else begin
                assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
            end
        end
    endgenerate
    
    // Final sum and carry out
    assign S = P ^ C[32:1];
    assign C32 = C[32];
endmodule