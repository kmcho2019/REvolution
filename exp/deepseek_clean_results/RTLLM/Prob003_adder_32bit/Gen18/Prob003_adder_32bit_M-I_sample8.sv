module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    input enable,
    output [15:0] S,
    output Cout,
    output Gout,
    output Pout
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // 4-bit block 0
    wire [3:0] G0 = enable ? (A[3:0] & B[3:0]) : 4'b0;
    wire [3:0] P0 = enable ? (A[3:0] ^ B[3:0]) : 4'b0;
    wire C1 = G0[0] | (P0[0] & Cin);
    wire C2 = G0[1] | (P0[1] & C1);
    wire C3 = G0[2] | (P0[2] & C2);
    wire C4 = G0[3] | (P0[3] & C3);
    assign S[3:0] = enable ? (P0 ^ {C3, C2, C1, Cin}) : 4'b0;
    
    // 4-bit block 1
    wire [3:0] G1 = enable ? (A[7:4] & B[7:4]) : 4'b0;
    wire [3:0] P1 = enable ? (A[7:4] ^ B[7:4]) : 4'b0;
    wire C5 = G1[0] | (P1[0] & C4);
    wire C6 = G1[1] | (P1[1] & C5);
    wire C7 = G1[2] | (P1[2] & C6);
    wire C8 = G1[3] | (P1[3] & C7);
    assign S[7:4] = enable ? (P1 ^ {C7, C6, C5, C4}) : 4'b0;
    
    // 4-bit block 2
    wire [3:0] G2 = enable ? (A[11:8] & B[11:8]) : 4'b0;
    wire [3:0] P2 = enable ? (A[11:8] ^ B[11:8]) : 4'b0;
    wire C9 = G2[0] | (P2[0] & C8);
    wire C10 = G2[1] | (P2[1] & C9);
    wire C11 = G2[2] | (P2[2] & C10);
    wire C12 = G2[3] | (P2[3] & C11);
    assign S[11:8] = enable ? (P2 ^ {C11, C10, C9, C8}) : 4'b0;
    
    // 4-bit block 3
    wire [3:0] G3 = enable ? (A[15:12] & B[15:12]) : 4'b0;
    wire [3:0] P3 = enable ? (A[15:12] ^ B[15:12]) : 4'b0;
    wire C13 = G3[0] | (P3[0] & C12);
    wire C14 = G3[1] | (P3[1] & C13);
    wire C15 = G3[2] | (P3[2] & C14);
    wire C16 = G3[3] | (P3[3] & C15);
    assign S[15:12] = enable ? (P3 ^ {C15, C14, C13, C12}) : 4'b0;
    
    // Group propagate/generate
    assign Gout = enable ? (G3[3] | (P3[3] & G2[3]) | (P3[3] & P2[3] & G1[3]) | 
                          (P3[3] & P2[3] & P1[3] & G0[3])) : 1'b0;
    assign Pout = enable ? (P3[3] & P2[3] & P1[3] & P0[3]) : 1'b0;
    assign Cout = enable ? C16 : 1'b0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    input enable,
    output [32:1] S,
    output C32
);
    wire G0, P0, C16;
    
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .enable(enable),
        .S(S[16:1]), 
        .Cout(), 
        .Gout(G0), 
        .Pout(P0)
    );
    
    // Second-level lookahead
    wire C16_lookahead = G0 | (P0 & 1'b0);
    
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16_lookahead), 
        .enable(enable),
        .S(S[32:17]), 
        .Cout(C32), 
        .Gout(), 
        .Pout()
    );
endmodule