// 4-bit Carry Lookahead Adder block
module cla_4bit (
    input  wire [4:1] A,
    input  wire [4:1] B,
    input  wire       Cin,
    output wire [4:1] S,
    output wire       Cout,
    output wire       P,  // Block propagate
    output wire       G   // Block generate
);
    wire [4:1] P_bit = A ^ B; // propagate signals per bit
    wire [4:1] G_bit = A & B; // generate signals per bit

    // Carry signals inside 4-bit block
    wire C1, C2, C3, C4;

    // Carry lookahead equations:
    // C1 = G0 + P0*Cin, similarly for others:
    assign C1 = G_bit[1] | (P_bit[1] & Cin);
    assign C2 = G_bit[2] | (P_bit[2] & C1);
    assign C3 = G_bit[3] | (P_bit[3] & C2);
    assign C4 = G_bit[4] | (P_bit[4] & C3);

    // Sum bits
    assign S = P_bit ^ {C3,C2,C1,Cin};

    assign Cout = C4;

    // Block propagate: all propagate bits ANDed
    assign P = &P_bit;

    // Block generate: complex for 4-bit block:
    // G = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]);
endmodule


// 16-bit CLA built from 4 x 4-bit CLA blocks
module cla_16bit (
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P, // Block propagate for 16-bit
    output wire        G  // Block generate for 16-bit
);
    wire [3:0] P_sub;   // propagate per 4-bit block
    wire [3:0] G_sub;   // generate per 4-bit block
    wire [3:0] C_sub;   // carries between 4-bit blocks; C_sub[0] = Cin

    assign C_sub[0] = Cin;

    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : four_bit_blocks
            // Slice input bits: each 4-bit slice [ (4*(i+1)) : (4*i+1) ]
            // Remember indexing 1-based: bits are [16:1]
            // i=0 => bits [4:1], i=1 => [8:5], i=2 => [12:9], i=3 => [16:13]
            // Use offset +1 for inclusive ranges:
            wire [4:1] A_part = A[(4*(i+1)) : (4*i+1)];
            wire [4:1] B_part = B[(4*(i+1)) : (4*i+1)];
            wire [4:1] S_part;
            wire Cout_part, P_part, G_part;

            cla_4bit cla4 (
                .A(A_part),
                .B(B_part),
                .Cin(C_sub[i]),
                .S(S_part),
                .Cout(Cout_part),
                .P(P_part),
                .G(G_part)
            );

            assign S[(4*(i+1)):(4*i+1)] = S_part;
            assign P_sub[i] = P_part;
            assign G_sub[i] = G_part;
        end
    endgenerate

    // Compute carries between 4-bit blocks in 16-bit CLA:
    // C_sub[1] = G_sub[0] | (P_sub[0] & C_sub[0])
    // C_sub[2] = G_sub[1] | (P_sub[1] & C_sub[1])
    // C_sub[3] = G_sub[2] | (P_sub[2] & C_sub[2])
    assign C_sub[1] = G_sub[0] | (P_sub[0] & C_sub[0]);
    assign C_sub[2] = G_sub[1] | (P_sub[1] & C_sub[1]);
    assign C_sub[3] = G_sub[2] | (P_sub[2] & C_sub[2]);
    assign Cout     = G_sub[3] | (P_sub[3] & C_sub[3]);

    // Block propagate and generate for 16 bits:
    assign P = &P_sub;
    // G = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 (like 4-bit block generate)
    assign G = G_sub[3] |
               (P_sub[3] & G_sub[2]) |
               (P_sub[3] & P_sub[2] & G_sub[1]) |
               (P_sub[3] & P_sub[2] & P_sub[1] & G_sub[0]);
endmodule


// 32-bit adder top module built from 2 x 16-bit CLA blocks
module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block (bits 16 downto 1)
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P_low),
        .G   (G_low)
    );

    // Carry-in for upper block:
    // Cin_high = G_low | (P_low & 0) = G_low
    wire Cin_high = G_low;

    // Upper 16-bit CLA block (bits 32 downto 17)
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (Cin_high),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P_high),
        .G   (G_high)
    );
endmodule