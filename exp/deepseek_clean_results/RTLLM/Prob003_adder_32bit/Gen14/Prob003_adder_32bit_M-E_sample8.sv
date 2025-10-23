module cla_4bit_bk (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Brent-Kung parallel prefix network
    wire [3:0] C;
    wire G10, P10, G32, P32, G3210, P3210;
    
    // First level
    assign G10 = G[1] | (P[1] & G[0]);
    assign P10 = P[1] & P[0];
    assign G32 = G[3] | (P[3] & G[2]);
    assign P32 = P[3] & P[2];
    
    // Second level
    assign G3210 = G32 | (P32 & G10);
    assign P3210 = P32 & P10;
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G10 | (P10 & Cin);
    assign C[3] = G3210 | (P3210 & Cin);
    
    assign S = P ^ C;
    assign G_out = G3210;
    assign P_out = P3210;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output G_out,
    output P_out
);
    wire G0, P0, G1, P1;
    wire carry_mid;
    
    cla_4bit_bk low (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                   .S(S[3:0]), .G_out(G0), .P_out(P0));
    cla_4bit_bk high (.A(A[7:4]), .B(B[7:4]), .Cin(carry_mid), 
                    .S(S[7:4]), .G_out(G1), .P_out(P1));
    
    // Block carry computation
    assign carry_mid = G0 | (P0 & Cin);
    assign G_out = G1 | (P1 & G0);
    assign P_out = P1 & P0;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output G_out,
    output P_out
);
    wire G0, P0, G1, P1;
    wire carry_mid;
    
    cla_8bit low (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), 
                 .S(S[7:0]), .G_out(G0), .P_out(P0));
    cla_8bit high (.A(A[15:8]), .B(B[15:8]), .Cin(carry_mid), 
                  .S(S[15:8]), .G_out(G1), .P_out(P1));
    
    // Block carry computation
    assign carry_mid = G0 | (P0 & Cin);
    assign G_out = G1 | (P1 & G0);
    assign P_out = P1 & P0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G0, P0, G1, P1;
    wire C16;
    
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), 
               .S(S[16:1]), .G_out(G0), .P_out(P0));
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), 
                  .S(S[32:17]), .G_out(G1), .P_out(P1));
    
    // Early carry-out prediction
    assign C16 = G0 | (P0 & 1'b0);
    assign C32 = G1 | (P1 & G0);
endmodule