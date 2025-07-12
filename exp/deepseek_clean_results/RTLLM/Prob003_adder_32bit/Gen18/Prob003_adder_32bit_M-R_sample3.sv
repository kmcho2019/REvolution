module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // Generate and propagate terms for all 4-bit segments
    wire [3:0] G0 = A[3:0] & B[3:0];
    wire [3:0] P0 = A[3:0] ^ B[3:0];
    wire [3:0] G1 = A[7:4] & B[7:4];
    wire [3:0] P1 = A[7:4] ^ B[7:4];
    wire [3:0] G2 = A[11:8] & B[11:8];
    wire [3:0] P2 = A[11:8] ^ B[11:8];
    wire [3:0] G3 = A[15:12] & B[15:12];
    wire [3:0] P3 = A[15:12] ^ B[15:12];

    // Carry computation for each 4-bit segment
    wire C0 = G0[0] | (P0[0] & Cin);
    wire C1 = G0[1] | (P0[1] & C0);
    wire C2 = G0[2] | (P0[2] & C1);
    wire C3 = G0[3] | (P0[3] & C2);
    
    wire C4 = G1[0] | (P1[0] & C3);
    wire C5 = G1[1] | (P1[1] & C4);
    wire C6 = G1[2] | (P1[2] & C5);
    wire C7 = G1[3] | (P1[3] & C6);
    
    wire C8 = G2[0] | (P2[0] & C7);
    wire C9 = G2[1] | (P2[1] & C8);
    wire C10 = G2[2] | (P2[2] & C9);
    wire C11 = G2[3] | (P2[3] & C10);
    
    wire C12 = G3[0] | (P3[0] & C11);
    wire C13 = G3[1] | (P3[1] & C12);
    wire C14 = G3[2] | (P3[2] & C13);
    wire C15 = G3[3] | (P3[3] & C14);

    // Sum computation
    assign S[3:0] = P0 ^ {C3, C2, C1, Cin};
    assign S[7:4] = P1 ^ {C7, C6, C5, C4};
    assign S[11:8] = P2 ^ {C11, C10, C9, C8};
    assign S[15:12] = P3 ^ {C15, C14, C13, C12};
    
    assign Cout = C15;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule