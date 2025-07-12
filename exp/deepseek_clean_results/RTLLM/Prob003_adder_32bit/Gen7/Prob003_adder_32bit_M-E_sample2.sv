module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Stage 1: Bitwise Generate and Propagate
    wire [32:1] G_bit = A & B;
    wire [32:1] P_bit = A ^ B;
    
    // Stage 2: 2-bit Group PG
    wire [16:1] G_2bit, P_2bit;
    genvar i;
    generate
        for (i = 1; i <= 16; i = i+1) begin : two_bit
            assign G_2bit[i] = G_bit[2*i] | (P_bit[2*i] & G_bit[2*i-1]);
            assign P_2bit[i] = P_bit[2*i] & P_bit[2*i-1];
        end
    endgenerate
    
    // Stage 3: 4-bit Group PG (Brent-Kung)
    wire [8:1] G_4bit, P_4bit;
    generate
        for (i = 1; i <= 8; i = i+1) begin : four_bit
            assign G_4bit[i] = G_2bit[2*i] | (P_2bit[2*i] & G_2bit[2*i-1]);
            assign P_4bit[i] = P_2bit[2*i] & P_2bit[2*i-1];
        end
    endgenerate
    
    // Stage 4: 8-bit Group PG (Kogge-Stone)
    wire [4:1] G_8bit, P_8bit;
    generate
        for (i = 1; i <= 4; i = i+1) begin : eight_bit
            assign G_8bit[i] = G_4bit[2*i] | (P_4bit[2*i] & G_4bit[2*i-1]);
            assign P_8bit[i] = P_4bit[2*i] & P_4bit[2*i-1];
        end
    endgenerate
    
    // Stage 5: 16-bit Group PG (Kogge-Stone)
    wire [2:1] G_16bit, P_16bit;
    assign G_16bit[1] = G_8bit[1];
    assign P_16bit[1] = P_8bit[1];
    assign G_16bit[2] = G_8bit[2] | (P_8bit[2] & G_8bit[1]);
    assign P_16bit[2] = P_8bit[2] & P_8bit[1];
    
    // Stage 6: 32-bit Group PG (Kogge-Stone)
    wire G_32bit = G_16bit[2] | (P_16bit[2] & G_16bit[1]);
    wire P_32bit = P_16bit[2] & P_16bit[1];
    assign C32 = G_32bit;
    
    // Carry Computation
    wire [32:0] C;
    assign C[0] = 1'b0;
    
    // Carry for 2-bit groups
    generate
        for (i = 1; i <= 16; i = i+1) begin : carry_2bit
            assign C[2*i] = G_2bit[i] | (P_2bit[i] & C[2*i-2]);
            assign C[2*i-1] = G_bit[2*i-1] | (P_bit[2*i-1] & C[2*i-2]);
        end
    endgenerate
    
    // Sum Computation
    assign S = P_bit ^ C[32:1];
endmodule