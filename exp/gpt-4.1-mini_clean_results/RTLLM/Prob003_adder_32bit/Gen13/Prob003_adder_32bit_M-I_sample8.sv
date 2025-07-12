module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,  // Block propagate
    output wire       G   // Block generate
);
    wire [3:0] p = A ^ B;
    wire [3:0] g = A & B;
    wire [4:0] c; // carry signals

    assign c[0] = Cin;

    // Carry lookahead logic for 4 bits:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign S = p ^ c[3:0];
    assign Cout = c[4];

    // Block propagate is AND of all propagate bits
    assign P = &p;

    // Block generate is G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G = c[4]; // Carry out when Cin=0 equals block generate
endmodule


module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [3:0] P_sub, G_sub;  // Propagate and generate for 4-bit sub-blocks
    wire [4:0] C_sub;         // carry for 4-bit blocks

    // Split inputs into four 4-bit blocks
    wire [3:0] A0 = A[3:0];
    wire [3:0] A1 = A[7:4];
    wire [3:0] A2 = A[11:8];
    wire [3:0] A3 = A[15:12];
    wire [3:0] B0 = B[3:0];
    wire [3:0] B1 = B[7:4];
    wire [3:0] B2 = B[11:8];
    wire [3:0] B3 = B[15:12];

    // Instantiate four 4-bit CLA sub-blocks
    cla_4bit cla0 (
        .A(A0),
        .B(B0),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(),
        .P(P_sub[0]),
        .G(G_sub[0])
    );
    cla_4bit cla1 (
        .A(A1),
        .B(B1),
        .Cin(C_sub[1]),
        .S(S[7:4]),
        .Cout(),
        .P(P_sub[1]),
        .G(G_sub[1])
    );
    cla_4bit cla2 (
        .A(A2),
        .B(B2),
        .Cin(C_sub[2]),
        .S(S[11:8]),
        .Cout(),
        .P(P_sub[2]),
        .G(G_sub[2])
    );
    cla_4bit cla3 (
        .A(A3),
        .B(B3),
        .Cin(C_sub[3]),
        .S(S[15:12]),
        .Cout(),
        .P(P_sub[3]),
        .G(G_sub[3])
    );

    // Calculate carries into each 4-bit block using 4-bit carry lookahead
    assign C_sub[0] = Cin;
    assign C_sub[1] = G_sub[0] | (P_sub[0] & C_sub[0]);
    assign C_sub[2] = G_sub[1] | (P_sub[1] & G_sub[0]) | (P_sub[1] & P_sub[0] & C_sub[0]);
    assign C_sub[3] = G_sub[2] | (P_sub[2] & G_sub[1]) | (P_sub[2] & P_sub[1] & G_sub[0]) | (P_sub[2] & P_sub[1] & P_sub[0] & C_sub[0]);
    assign Cout    = G_sub[3] | (P_sub[3] & G_sub[2]) | (P_sub[3] & P_sub[2] & G_sub[1]) | (P_sub[3] & P_sub[2] & P_sub[1] & G_sub[0]) | (P_sub[3] & P_sub[2] & P_sub[1] & P_sub[0] & C_sub[0]);

    // Block propagate and generate for 16-bit block
    assign P = &P_sub;
    assign G = Cout;  // carry-out with Cin=0 is block generate
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Lower 16-bit CLA block with Cin=0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Compute carry-in for upper block:
    // Cin_high = G_low + P_low * 0 = G_low (top Cin=0)
    wire Cin_high = G_low;

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map outputs back to 1-based indexing
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate
endmodule