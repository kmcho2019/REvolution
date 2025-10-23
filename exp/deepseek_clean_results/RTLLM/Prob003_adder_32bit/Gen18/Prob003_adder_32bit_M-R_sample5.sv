module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Lower 16-bit block
    wire [3:0] G_low = {A[16:13] & B[16:13], A[12:9] & B[12:9], 
               A[8:5] & B[8:5], A[4:1] & B[4:1]};
    wire [3:0] P_low = {A[16:13] ^ B[16:13], A[12:9] ^ B[12:9], 
               A[8:5] ^ B[8:5], A[4:1] ^ B[4:1]};
    
    wire C4_low = G_low[0] | (P_low[0] & 1'b0);
    wire C8_low = G_low[1] | (P_low[1] & C4_low);
    wire C12_low = G_low[2] | (P_low[2] & C8_low);
    wire C16 = G_low[3] | (P_low[3] & C12_low);
    
    assign S[4:1] = P_low[0] ^ {4{1'b0}};
    assign S[8:5] = P_low[1] ^ {4{C4_low}};
    assign S[12:9] = P_low[2] ^ {4{C8_low}};
    assign S[16:13] = P_low[3] ^ {4{C12_low}};

    // Upper 16-bit block
    wire [3:0] G_high = {A[32:29] & B[32:29], A[28:25] & B[28:25], 
                A[24:21] & B[24:21], A[20:17] & B[20:17]};
    wire [3:0] P_high = {A[32:29] ^ B[32:29], A[28:25] ^ B[28:25], 
                A[24:21] ^ B[24:21], A[20:17] ^ B[20:17]};
    
    wire C20 = G_high[0] | (P_high[0] & C16);
    wire C24 = G_high[1] | (P_high[1] & C20);
    wire C28 = G_high[2] | (P_high[2] & C24);
    wire C32 = G_high[3] | (P_high[3] & C28);
    
    assign S[20:17] = P_high[0] ^ {4{C16}};
    assign S[24:21] = P_high[1] ^ {4{C20}};
    assign S[28:25] = P_high[2] ^ {4{C24}};
    assign S[32:29] = P_high[3] ^ {4{C28}};
endmodule