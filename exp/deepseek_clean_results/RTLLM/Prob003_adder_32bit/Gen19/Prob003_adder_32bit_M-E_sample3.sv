module brent_kung_8carry (
    input [7:0] G,
    input [7:0] P,
    input Cin,
    output [7:0] Cout
);
    // First level
    wire [3:0] G1, P1;
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[2] = P[2] & P[1];
    assign G1[3] = G[3] | (P[3] & G[2]);
    assign P1[3] = P[3] & P[2];

    // Second level
    wire [1:0] G2, P2;
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[0] = P1[1] & P1[0];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];

    // Third level
    wire G3 = G2[1] | (P2[1] & G2[0]);
    wire P3 = P2[1] & P2[0];

    // Carry generation
    assign Cout[0] = Cin;
    assign Cout[1] = G1[0] | (P1[0] & Cin);
    assign Cout[2] = G2[0] | (P2[0] & Cin);
    assign Cout[3] = G1[2] | (P1[2] & Cout[2]);
    assign Cout[4] = G3 | (P3 & Cin);
    assign Cout[5] = G1[4] | (P1[4] & Cout[4]);
    assign Cout[6] = G2[2] | (P2[2] & Cout[4]);
    assign Cout[7] = G1[6] | (P1[6] & Cout[6]);
endmodule

module cla_4bit_segment (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P
);
    wire [3:0] G_local = A & B;
    wire [3:0] P_local = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_local[0] | (P_local[0] & C[0]);
    assign C[2] = G_local[1] | (P_local[1] & C[1]);
    assign C[3] = G_local[2] | (P_local[2] & C[2]);
    
    assign G = G_local[3] | (P_local[3] & G_local[2] | 
             (P_local[3] & P_local[2] & G_local[1]) |
             (P_local[3] & P_local[2] & P_local[1] & G_local[0]);
    assign P = &P_local;
    assign S = P_local ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] G_seg, P_seg;
    wire [7:0] seg_carry;
    
    // Generate segment P/G and sum bits
    cla_4bit_segment seg0 (.A(A[4:1]), .B(B[4:1]), .Cin(seg_carry[0]), 
                     .S(S[4:1]), .G(G_seg[0]), .P(P_seg[0]));
    cla_4bit_segment seg1 (.A(A[8:5]), .B(B[8:5]), .Cin(seg_carry[1]), 
                     .S(S[8:5]), .G(G_seg[1]), .P(P_seg[1]));
    cla_4bit_segment seg2 (.A(A[12:9]), .B(B[12:9]), .Cin(seg_carry[2]), 
                     .S(S[12:9]), .G(G_seg[2]), .P(P_seg[2]));
    cla_4bit_segment seg3 (.A(A[16:13]), .B(B[16:13]), .Cin(seg_carry[3]), 
                     .S(S[16:13]), .G(G_seg[3]), .P(P_seg[3]));
    cla_4bit_segment seg4 (.A(A[20:17]), .B(B[20:17]), .Cin(seg_carry[4]), 
                     .S(S[20:17]), .G(G_seg[4]), .P(P_seg[4]));
    cla_4bit_segment seg5 (.A(A[24:21]), .B(B[24:21]), .Cin(seg_carry[5]), 
                     .S(S[24:21]), .G(G_seg[5]), .P(P_seg[5]));
    cla_4bit_segment seg6 (.A(A[28:25]), .B(B[28:25]), .Cin(seg_carry[6]), 
                     .S(S[28:25]), .G(G_seg[6]), .P(P_seg[6]));
    cla_4bit_segment seg7 (.A(A[32:29]), .B(B[32:29]), .Cin(seg_carry[7]), 
                     .S(S[32:29]), .G(G_seg[7]), .P(P_seg[7]));

    // Brent-Kung carry tree
    brent_kung_8carry carry_tree (
        .G(G_seg),
        .P(P_seg),
        .Cin(1'b0),
        .Cout(seg_carry)
    );
    
    assign C32 = seg_carry[7] | (P_seg[7] & G_seg[6] | 
                (P_seg[7] & P_seg[6] & G_seg[5]) |
                (P_seg[7] & P_seg[6] & P_seg[5] & G_seg[4]) |
                (P_seg[7] & P_seg[6] & P_seg[5] & P_seg[4] & seg_carry[3]);
endmodule