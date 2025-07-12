module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Internal carry signals
    wire [3:0] carry_low;
    wire [3:0] carry_high;
    wire C16;
    
    // Generate 4-bit CLAs for lower 16 bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LOW_CLA
            wire [3:0] G = A[(i*4+4):(i*4+1)] & B[(i*4+4):(i*4+1)];
            wire [3:0] P = A[(i*4+4):(i*4+1)] ^ B[(i*4+4):(i*4+1)];
            wire [3:0] C;
            
            assign C[0] = (i == 0) ? 1'b0 : carry_low[i-1];
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & C[1]);
            assign C[3] = G[2] | (P[2] & C[2]);
            
            assign S[(i*4+4):(i*4+1)] = P ^ C;
            assign carry_low[i] = G[3] | (P[3] & C[3]);
        end
    endgenerate
    
    assign C16 = carry_low[3];
    
    // Generate 4-bit CLAs for upper 16 bits
    generate
        for (i = 0; i < 4; i = i + 1) begin : HIGH_CLA
            wire [3:0] G = A[(i*4+20):(i*4+17)] & B[(i*4+20):(i*4+17)];
            wire [3:0] P = A[(i*4+20):(i*4+17)] ^ B[(i*4+20):(i*4+17)];
            wire [3:0] C;
            
            assign C[0] = (i == 0) ? C16 : carry_high[i-1];
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & C[1]);
            assign C[3] = G[2] | (P[2] & C[2]);
            
            assign S[(i*4+20):(i*4+17)] = P ^ C;
            assign carry_high[i] = G[3] | (P[3] & C[3]);
        end
    endgenerate
    
    assign C32 = carry_high[3];
endmodule