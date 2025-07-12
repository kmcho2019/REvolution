module cla_4bit (
    input  [4:1] P, G,
    input        Cin,
    output [4:1] C,
    output       P_group,
    output       G_group
);
    // Carry lookahead logic for 4 bits
    assign C[1] = G[1] | (P[1] & Cin);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & Cin);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & Cin);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1])
                  | (P[4] & P[3] & P[2] & P[1] & Cin);

    assign P_group = &P; // AND of all P bits
    assign G_group = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
endmodule

module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P_block,  // Block propagate for 16 bits
    output        G_block   // Block generate for 16 bits
);
    wire [16:1] P, G;
    wire [16:1] C;
    wire [4:1] P_group, G_group;
    wire [4:0] C_group; // Carry-in for each 4-bit group

    assign P = A ^ B;
    assign G = A & B;
    assign C_group[0] = Cin;

    // Instantiate four 4-bit CLA units
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : block4
            cla_4bit cla4 (
                .P      (P[4*i+4:4*i+1]),
                .G      (G[4*i+4:4*i+1]),
                .Cin    (C_group[i]),
                .C      (C[4*i+4:4*i+1]),
                .P_group(P_group[i+1]),
                .G_group(G_group[i+1])
            );
        end
    endgenerate

    // Compute carries between 4-bit blocks (4 groups)
    // Using group P and G signals
    assign C_group[1] = G_group[1] | (P_group[1] & Cin);
    assign C_group[2] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & Cin);
    assign C_group[3] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & Cin);
    assign C_group[4] = G_group[4] | (P_group[4] & G_group[3]) | (P_group[4] & P_group[3] & G_group[2]) | (P_group[4] & P_group[3] & P_group[2] & G_group[1])
                        | (P_group[4] & P_group[3] & P_group[2] & P_group[1] & Cin);

    // Sum bits
    assign S = P ^ C;

    // Block propagate and generate for the whole 16-bit block
    assign P_block = &P_group; // AND of all 4 group propagates
    assign G_block = G_group[4] | (P_group[4] & G_group[3]) | (P_group[4] & P_group[3] & G_group[2])
                     | (P_group[4] & P_group[3] & P_group[2] & G_group[1]);

    assign Cout = C_group[4];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P_lo, G_lo, P_hi, G_hi;
    wire Cin_hi;

    // Lower 16-bit CLA block
    cla_16bit lower_half (
        .A       (A[16:1]),
        .B       (B[16:1]),
        .Cin     (1'b0),
        .S       (S[16:1]),
        .Cout    (C16),
        .P_block (P_lo),
        .G_block (G_lo)
    );

    // Calculate carry-in for upper half using block CLA logic
    assign Cin_hi = G_lo | (P_lo & 1'b0); // 1'b0 is Cin for lower half

    // Upper 16-bit CLA block
    cla_16bit upper_half (
        .A       (A[32:17]),
        .B       (B[32:17]),
        .Cin     (Cin_hi),
        .S       (S[32:17]),
        .Cout    (C32),
        .P_block (P_hi),
        .G_block (G_hi)
    );
endmodule