module hybrid_adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // First 8 bits use traditional CLA for fastest initial carry
    wire [7:0] S_low;
    wire C8;
    cla_8bit low_adder (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C8)
    );
    assign S[8:1] = S_low;

    // Middle 14 bits use carry-select with conditional sum
    wire [13:0] S_mid_0, S_mid_1;
    wire C22_0, C22_1;
    
    // Block 1: 5 bits
    csa_5bit mid_adder1_0 (
        .A(A[13:9]),
        .B(B[13:9]),
        .Cin(1'b0),
        .S(S_mid_0[4:0]),
        .Cout(C13_0)
    );
    csa_5bit mid_adder1_1 (
        .A(A[13:9]),
        .B(B[13:9]),
        .Cin(1'b1),
        .S(S_mid_1[4:0]),
        .Cout(C13_1)
    );

    // Block 2: 6 bits
    csa_6bit mid_adder2_0 (
        .A(A[19:14]),
        .B(B[19:14]),
        .Cin(1'b0),
        .S(S_mid_0[10:5]),
        .Cout(C19_0)
    );
    csa_6bit mid_adder2_1 (
        .A(A[19:14]),
        .B(B[19:14]),
        .Cin(1'b1),
        .S(S_mid_1[10:5]),
        .Cout(C19_1)
    );

    // Block 3: 7 bits
    csa_7bit mid_adder3_0 (
        .A(A[26:20]),
        .B(B[26:20]),
        .Cin(1'b0),
        .S(S_mid_0[17:11]),
        .Cout(C26_0)
    );
    csa_7bit mid_adder3_1 (
        .A(A[26:20]),
        .B(B[26:20]),
        .Cin(1'b1),
        .S(S_mid_1[17:11]),
        .Cout(C26_1)
    );

    // Final 6 bits use carry-skip with lookahead
    wire [5:0] S_high;
    wire C32;
    cla_6bit high_adder (
        .A(A[32:27]),
        .B(B[32:27]),
        .Cin(C26),
        .S(S_high),
        .Cout(C32)
    );
    assign S[32:27] = S_high;

    // Carry select muxes
    wire C13 = C8 ? C13_1 : C13_0;
    wire C19 = C13 ? C19_1 : C19_0;
    wire C26 = C19 ? C26_1 : C26_0;
    
    assign S[26:9] = C8 ? S_mid_1[17:0] : S_mid_0[17:0];
endmodule

// Supporting modules
module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    wire [7:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
    
    assign S = P ^ {C[6:0], Cin};
    assign Cout = C[7];
endmodule

module csa_5bit (
    input [4:0] A,
    input [4:0] B,
    input Cin,
    output [4:0] S,
    output Cout
);
    wire [4:0] G = A & B;
    wire [4:0] P = A ^ B;
    
    wire [4:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    
    assign S = P ^ {C[3:0], Cin};
    assign Cout = C[4];
endmodule

module csa_6bit (
    input [5:0] A,
    input [5:0] B,
    input Cin,
    output [5:0] S,
    output Cout
);
    wire [5:0] G = A & B;
    wire [5:0] P = A ^ B;
    
    wire [5:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    
    assign S = P ^ {C[4:0], Cin};
    assign Cout = C[5];
endmodule

module csa_7bit (
    input [6:0] A,
    input [6:0] B,
    input Cin,
    output [6:0] S,
    output Cout
);
    wire [6:0] G = A & B;
    wire [6:0] P = A ^ B;
    
    wire [6:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    
    assign S = P ^ {C[5:0], Cin};
    assign Cout = C[6];
endmodule

module cla_6bit (
    input [5:0] A,
    input [5:0] B,
    input Cin,
    output [5:0] S,
    output Cout
);
    wire [5:0] G = A & B;
    wire [5:0] P = A ^ B;
    
    wire [5:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    
    assign S = P ^ {C[4:0], Cin};
    assign Cout = C[5];
endmodule