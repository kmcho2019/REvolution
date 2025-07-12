module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Stage 1: Bitwise P and G generation
    wire [32:1] P, G;
    assign P = A ^ B;
    assign G = A & B;
    
    // Stage 2: 4-bit group P and G
    wire [7:0] Pg4, Gg4;
    genvar i;
    generate
        for (i = 0; i < 8; i = i+1) begin : group4
            localparam hi = (i+1)*4;
            localparam lo = i*4 + 1;
            assign Pg4[i] = &P[hi:lo];
            assign Gg4[i] = G[hi] | 
                          (P[hi] & G[hi-1]) | 
                          (P[hi] & P[hi-1] & G[hi-2]) | 
                          (P[hi] & P[hi-1] & P[hi-2] & G[lo]);
        end
    endgenerate
    
    // Stage 3: Carry computation (Brent-Kung structure)
    wire [7:0] C4;
    assign C4[0] = 1'b0;  // Initial carry-in
    
    // First level carry (4-bit groups)
    assign C4[1] = Gg4[0] | (Pg4[0] & C4[0]);
    assign C4[2] = Gg4[1] | (Pg4[1] & Gg4[0]) | (Pg4[1] & Pg4[0] & C4[0]);
    assign C4[3] = Gg4[2] | (Pg4[2] & Gg4[1]) | (Pg4[2] & Pg4[1] & Gg4[0]) | 
                  (Pg4[2] & Pg4[1] & Pg4[0] & C4[0]);
    
    // Second level carry (16-bit groups)
    wire [1:0] Pg16, Gg16;
    assign Pg16[0] = &Pg4[3:0];
    assign Gg16[0] = Gg4[3] | (Pg4[3] & Gg4[2]) | (Pg4[3] & Pg4[2] & Gg4[1]) | 
                    (Pg4[3] & Pg4[2] & Pg4[1] & Gg4[0]);
    
    assign C4[4] = Gg16[0] | (Pg16[0] & C4[0]);
    assign C4[5] = Gg4[4] | (Pg4[4] & C4[4]);
    assign C4[6] = Gg4[5] | (Pg4[5] & Gg4[4]) | (Pg4[5] & Pg4[4] & C4[4]);
    assign C4[7] = Gg4[6] | (Pg4[6] & Gg4[5]) | (Pg4[6] & Pg4[5] & Gg4[4]) | 
                  (Pg4[6] & Pg4[5] & Pg4[4] & C4[4]);
    
    assign Pg16[1] = &Pg4[7:4];
    assign Gg16[1] = Gg4[7] | (Pg4[7] & Gg4[6]) | (Pg4[7] & Pg4[6] & Gg4[5]) | 
                    (Pg4[7] & Pg4[6] & Pg4[5] & Gg4[4]);
    assign C32 = Gg16[1] | (Pg16[1] & Gg16[0]);
    
    // Stage 4: Sum computation
    wire [32:0] C;
    assign C[0] = 1'b0;
    assign C[4:1] = C4[0] ? 4'b0001 : 4'b0000;
    assign C[8:5] = C4[1] ? 4'b0001 : 4'b0000;
    assign C[12:9] = C4[2] ? 4'b0001 : 4'b0000;
    assign C[16:13] = C4[3] ? 4'b0001 : 4'b0000;
    assign C[20:17] = C4[4] ? 4'b0001 : 4'b0000;
    assign C[24:21] = C4[5] ? 4'b0001 : 4'b0000;
    assign C[28:25] = C4[6] ? 4'b0001 : 4'b0000;
    assign C[32:29] = C4[7] ? 4'b0001 : 4'b0000;
    
    assign S = P ^ C[32:1];
endmodule