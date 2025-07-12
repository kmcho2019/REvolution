module pg_unit(
    input A,
    input B,
    output P,
    output G
);
    assign P = A ^ B;
    assign G = A & B;
endmodule

module carry_combine(
    input P1, G1,
    input P2, G2,
    output Po, Go
);
    assign Po = P1 & P2;
    assign Go = G2 | (P2 & G1);
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] P, G;
    wire [7:0] C;
    
    // Generate PG terms
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pg_gen
            pg_unit pg(.A(A[i]), .B(B[i]), .P(P[i]), .G(G[i]));
        end
    endgenerate
    
    // Brent-Kung parallel prefix tree
    // First level
    wire [3:0] P1, G1;
    carry_combine cc0(.P1(P[0]), .G1(G[0]), .P2(P[1]), .G2(G[1]), .Po(P1[0]), .Go(G1[0]));
    carry_combine cc1(.P1(P[2]), .G1(G[2]), .P2(P[3]), .G2(G[3]), .Po(P1[1]), .Go(G1[1]));
    carry_combine cc2(.P1(P[4]), .G1(G[4]), .P2(P[5]), .G2(G[5]), .Po(P1[2]), .Go(G1[2]));
    carry_combine cc3(.P1(P[6]), .G1(G[6]), .P2(P[7]), .G2(G[7]), .Po(P1[3]), .Go(G1[3]));
    
    // Second level
    wire [1:0] P2, G2;
    carry_combine cc4(.P1(P1[0]), .G1(G1[0]), .P2(P1[1]), .G2(G1[1]), .Po(P2[0]), .Go(G2[0]));
    carry_combine cc5(.P1(P1[2]), .G1(G1[2]), .P2(P1[3]), .G2(G1[3]), .Po(P2[1]), .Go(G2[1]));
    
    // Third level
    wire P3, G3;
    carry_combine cc6(.P1(P2[0]), .G1(G2[0]), .P2(P2[1]), .G2(G2[1]), .Po(P3), .Go(G3));
    
    // Generate carries
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G1[0] | (P1[0] & C[0]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G2[0] | (P2[0] & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G1[2] | (P1[2] & C[4]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign Cout = G3 | (P3 & C[0]);
    
    // Generate sum
    assign S = P ^ {C[6:0], Cin};
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire C8;
    
    cla_8bit cla0 (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), .S(S[7:0]), .Cout(C8));
    cla_8bit cla1 (.A(A[15:8]), .B(B[15:8]), .Cin(C8), .S(S[15:8]), .Cout(Cout));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(C16));
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Cout(C32));
endmodule