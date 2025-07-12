// 4-bit Carry Lookahead Adder Block
module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,  // Block propagate
    output wire       G   // Block generate
);
    wire [3:0] p, g;
    wire [4:0] c;

    // Propagate and generate per bit
    assign p = A ^ B;
    assign g = A & B;

    assign c[0] = Cin;
    // Carry lookahead logic for 4 bits
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum bits
    assign S = p ^ c[3:0];

    // Block propagate and generate for 4-bit block
    assign P = &p;         // all propagate bits ANDed
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    assign Cout = c[4];
endmodule

// 16-bit Carry Lookahead Adder using four 4-bit CLA blocks
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [3:0] P_block, G_block; // Propagate and generate for each 4-bit block
    wire [4:0] c;                // carry signals for block boundaries and bits

    // Divide inputs into 4-bit chunks
    wire [3:0] A0 = A[3:0];
    wire [3:0] A1 = A[7:4];
    wire [3:0] A2 = A[11:8];
    wire [3:0] A3 = A[15:12];

    wire [3:0] B0 = B[3:0];
    wire [3:0] B1 = B[7:4];
    wire [3:0] B2 = B[11:8];
    wire [3:0] B3 = B[15:12];

    wire [3:0] S0, S1, S2, S3;

    // First-level: instantiate four 4-bit CLA blocks
    cla_4bit cla0 (
        .A(A0), .B(B0), .Cin(c[0]), .S(S0), .Cout(), .P(P_block[0]), .G(G_block[0])
    );
    cla_4bit cla1 (
        .A(A1), .B(B1), .Cin(c[1]), .S(S1), .Cout(), .P(P_block[1]), .G(G_block[1])
    );
    cla_4bit cla2 (
        .A(A2), .B(B2), .Cin(c[2]), .S(S2), .Cout(), .P(P_block[2]), .G(G_block[2])
    );
    cla_4bit cla3 (
        .A(A3), .B(B3), .Cin(c[3]), .S(S3), .Cout(), .P(P_block[3]), .G(G_block[3])
    );

    // Second-level: 4-bit block carry lookahead for the four 4-bit blocks
    // c[0] = Cin (input carry)
    assign c[0] = Cin;

    assign c[1] = G_block[0] | (P_block[0] & c[0]);
    assign c[2] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & c[0]);
    assign c[3] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0])
                | (P_block[2] & P_block[1] & P_block[0] & c[0]);
    assign c[4] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1])
                | (P_block[3] & P_block[2] & P_block[1] & G_block[0])
                | (P_block[3] & P_block[2] & P_block[1] & P_block[0] & c[0]);

    // Combine sum outputs
    assign S = {S3, S2, S1, S0};
    assign Cout = c[4];
endmodule

// Top-level 32-bit adder using two 16-bit CLA blocks
module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block, carry-in = carry-out of lower block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum outputs back to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule