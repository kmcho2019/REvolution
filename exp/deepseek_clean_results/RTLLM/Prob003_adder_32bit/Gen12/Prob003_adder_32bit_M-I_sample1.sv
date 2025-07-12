module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P,
    output Cout
);
    wire [3:0] G_bit = A & B;
    wire [3:0] P_bit = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign Cout = G_bit[3] | (P_bit[3] & C[3]);
    
    assign S = P_bit ^ C;
    assign G = G_bit[3] | (P_bit[3] & G_bit[2]) | 
              (P_bit[3] & P_bit[2] & G_bit[1]) | 
              (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
    assign P = &P_bit;
endmodule

module carry_lookahead_unit (
    input [7:0] G,
    input [7:0] P,
    input Cin,
    output [7:0] Cout
);
    assign Cout[0] = G[0] | (P[0] & Cin);
    assign Cout[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign Cout[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | 
                    (P[2] & P[1] & P[0] & Cin);
    assign Cout[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
                    (P[3] & P[2] & P[1] & G[0]) | 
                    (P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | 
                    (P[4] & P[3] & P[2] & G[1]) | 
                    (P[4] & P[3] & P[2] & P[1] & G[0]) | 
                    (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | 
                    (P[5] & P[4] & P[3] & G[2]) | 
                    (P[5] & P[4] & P[3] & P[2] & G[1]) | 
                    (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                    (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | 
                    (P[6] & P[5] & P[4] & G[3]) | 
                    (P[6] & P[5] & P[4] & P[3] & G[2]) | 
                    (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                    (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                    (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
                    (P[7] & P[6] & P[5] & G[4]) | 
                    (P[7] & P[6] & P[5] & P[4] & G[3]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] G, P;
    wire [7:0] carry_out;
    
    // First level: 8x 4-bit CLAs
    cla_4bit cla0 (.A(A[4:1]), .B(B[4:1]), .Cin(1'b0), .S(S[4:1]), .G(G[0]), .P(P[0]), .Cout());
    cla_4bit cla1 (.A(A[8:5]), .B(B[8:5]), .Cin(carry_out[0]), .S(S[8:5]), .G(G[1]), .P(P[1]), .Cout());
    cla_4bit cla2 (.A(A[12:9]), .B(B[12:9]), .Cin(carry_out[1]), .S(S[12:9]), .G(G[2]), .P(P[2]), .Cout());
    cla_4bit cla3 (.A(A[16:13]), .B(B[16:13]), .Cin(carry_out[2]), .S(S[16:13]), .G(G[3]), .P(P[3]), .Cout());
    cla_4bit cla4 (.A(A[20:17]), .B(B[20:17]), .Cin(carry_out[3]), .S(S[20:17]), .G(G[4]), .P(P[4]), .Cout());
    cla_4bit cla5 (.A(A[24:21]), .B(B[24:21]), .Cin(carry_out[4]), .S(S[24:21]), .G(G[5]), .P(P[5]), .Cout());
    cla_4bit cla6 (.A(A[28:25]), .B(B[28:25]), .Cin(carry_out[5]), .S(S[28:25]), .G(G[6]), .P(P[6]), .Cout());
    cla_4bit cla7 (.A(A[32:29]), .B(B[32:29]), .Cin(carry_out[6]), .S(S[32:29]), .G(G[7]), .P(P[7]), .Cout());
    
    // Second level: Carry Lookahead Unit
    carry_lookahead_unit clu (
        .G(G),
        .P(P),
        .Cin(1'b0),
        .Cout(carry_out)
    );
    
    assign C32 = carry_out[7];
endmodule