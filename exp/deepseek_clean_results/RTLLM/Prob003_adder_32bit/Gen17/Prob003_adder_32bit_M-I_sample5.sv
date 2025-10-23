module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // Carry computation using lookahead
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    wire C5 = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | 
              (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    wire C6 = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | 
              (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
              (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    wire C7 = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | 
              (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
              (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    
    assign Cout = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | 
                 (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
                 (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    
    assign S = P ^ {C7, C6, C5, C4, C3, C2, C1, Cin};
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