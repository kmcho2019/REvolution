// 4-bit Carry Lookahead Adder block
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       P,    // group propagate
    output       G,    // group generate
    output       Cout
);
    wire [4:1] P_bit, G_bit;
    wire [4:0] C; // carries: C[0] = Cin, C[4] = Cout

    assign C[0] = Cin;

    // Generate propagate and generate for each bit
    genvar i;
    generate
        for(i = 1; i <=4; i = i+1) begin : pg_gen
            assign P_bit[i] = A[i] ^ B[i];
            assign G_bit[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead equations for 4 bits
    assign C[1] = G_bit[1] | (P_bit[1] & C[0]);
    assign C[2] = G_bit[2] | (P_bit[2] & G_bit[1]) | (P_bit[2] & P_bit[1] & C[0]);
    assign C[3] = G_bit[3] | (P_bit[3] & G_bit[2]) | (P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[3] & P_bit[2] & P_bit[1] & C[0]);
    assign C[4] = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1])
                  | (P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & C[0]);

    assign Cout = C[4];
    assign S = P_bit ^ C[3:0];

    // Group propagate and generate
    assign P = &P_bit[4:1]; // all propagate bits ANDed
    assign G = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]);
endmodule


// 16-bit CLA: four 4-bit CLA blocks + carry lookahead generator for block carries
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [4:1] P_block, G_block; // group P and G from each 4-bit block
    wire [4:0] C_block;          // carry into each 4-bit block, C_block[0] = Cin

    assign C_block[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : cla4_blocks
            cla_4bit cla4 (
                .A(A[4*i+4:4*i+1]),
                .B(B[4*i+4:4*i+1]),
                .Cin(C_block[i]),
                .S(S[4*i+4:4*i+1]),
                .P(P_block[i+1]),
                .G(G_block[i+1]),
                .Cout() // not used here
            );
        end
    endgenerate

    // Carry lookahead for block carries C_block[1..4]
    // C_block[i] = G_block[i] + P_block[i]*C_block[i-1]
    assign C_block[1] = G_block[1] | (P_block[1] & C_block[0]);
    assign C_block[2] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & C_block[0]);
    assign C_block[3] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | (P_block[3] & P_block[2] & P_block[1] & C_block[0]);
    assign C_block[4] = G_block[4] | (P_block[4] & G_block[3]) | (P_block[4] & P_block[3] & G_block[2]) | (P_block[4] & P_block[3] & P_block[2] & G_block[1])
                        | (P_block[4] & P_block[3] & P_block[2] & P_block[1] & C_block[0]);

    assign Cout = C_block[4];
endmodule


// 32-bit adder: two 16-bit CLA blocks + carry lookahead generator for two blocks
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16; // carry out from lower 16 bits

    // Instantiate lower 16-bit CLA block, carry in = 0
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Instantiate upper 16-bit CLA block, carry in = C16
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule