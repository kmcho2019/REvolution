module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Lower 16-bit CLA implementation
    wire [15:0] G_low = A[16:1] & B[16:1];
    wire [15:0] P_low = A[16:1] ^ B[16:1];
    
    // Carry computation for lower 16 bits
    wire [16:0] C_low;
    assign C_low[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_low_carry
            assign C_low[i+1] = G_low[i] | (P_low[i] & C_low[i]);
        end
    endgenerate
    
    // Sum computation for lower 16 bits
    assign S[16:1] = P_low ^ C_low[15:0];
    
    // Upper 16-bit CLA implementation
    wire [15:0] G_high = A[32:17] & B[32:17];
    wire [15:0] P_high = A[32:17] ^ B[32:17];
    
    // Carry computation for upper 16 bits
    wire [16:0] C_high;
    assign C_high[0] = C_low[16];
    
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_high_carry
            assign C_high[i+1] = G_high[i] | (P_high[i] & C_high[i]);
        end
    endgenerate
    
    // Sum computation for upper 16 bits
    assign S[32:17] = P_high ^ C_high[15:0];
    
    // Final carry out
    assign C32 = C_high[16];
endmodule