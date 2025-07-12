module ppg_8bit (
    input [7:0] A,
    input [7:0] B,
    output [7:0] P,
    output [7:0] G
);
    assign P = A ^ B;
    assign G = A & B;
endmodule

module brent_kung_8bit (
    input [7:0] P,
    input [7:0] G,
    input Cin,
    output [7:0] C,
    output Cout
);
    // First level - bitwise
    wire [7:0] G1, P1;
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bk_first
            assign G1[i] = G[i] | (P[i] & G[i-1]);
            assign P1[i] = P[i] & P[i-1];
        end
    endgenerate

    // Second level - 2-bit groups
    wire [3:0] G2, P2;
    assign G2[0] = G1[1];
    assign P2[0] = P1[1];
    
    for (i = 1; i < 4; i = i + 1) begin : bk_second
        assign G2[i] = G1[2*i+1] | (P1[2*i+1] & G1[2*i-1]);
        assign P2[i] = P1[2*i+1] & P1[2*i-1];
    end

    // Final level - 4-bit groups
    wire [1:0] G3, P3;
    assign G3[0] = G2[1];
    assign P3[0] = P2[1];
    assign G3[1] = G2[3] | (P2[3] & G2[1]);
    assign P3[1] = P2[3] & P2[1];

    // Carry generation
    assign C[0] = Cin;
    assign C[1] = G1[0];
    assign C[2] = G1[1];
    assign C[3] = G2[0] | (P2[0] & G1[0]);
    assign C[4] = G2[1];
    assign C[5] = G1[5] | (P1[5] & G2[1]);
    assign C[6] = G1[6] | (P1[6] & G1[5]) | (P1[6] & P1[5] & G2[1]);
    assign C[7] = G3[1];
    assign Cout = G3[1];
endmodule

module hybrid_8bit_cla (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] P, G;
    wire [7:0] C;
    
    ppg_8bit ppg (.A(A), .B(B), .P(P), .G(G));
    brent_kung_8bit bk (.P(P), .G(G), .Cin(Cin), .C(C), .Cout(Cout));
    
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] block_cout;
    
    hybrid_8bit_cla block0 (
        .A(A[8:1]), 
        .B(B[8:1]), 
        .Cin(1'b0),
        .S(S[8:1]),
        .Cout(block_cout[0])
    );
    
    hybrid_8bit_cla block1 (
        .A(A[16:9]), 
        .B(B[16:9]), 
        .Cin(block_cout[0]),
        .S(S[16:9]),
        .Cout(block_cout[1])
    );
    
    hybrid_8bit_cla block2 (
        .A(A[24:17]), 
        .B(B[24:17]), 
        .Cin(block_cout[1]),
        .S(S[24:17]),
        .Cout(block_cout[2])
    );
    
    hybrid_8bit_cla block3 (
        .A(A[32:25]), 
        .B(B[32:25]), 
        .Cin(block_cout[2]),
        .S(S[32:25]),
        .Cout(block_cout[3])
    );
    
    // Carry-select optimization for final carry
    wire [7:0] P_hi, G_hi;
    ppg_8bit ppg_hi (.A(A[32:25]), .B(B[32:25]), .P(P_hi), .G(G_hi));
    
    assign C32 = G_hi[7] | (P_hi[7] & block_cout[2]);
endmodule