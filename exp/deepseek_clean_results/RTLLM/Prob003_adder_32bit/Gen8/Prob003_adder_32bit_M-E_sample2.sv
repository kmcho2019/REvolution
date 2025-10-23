module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    assign S = P ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire carry_mid;
    wire [1:0] P, G;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(carry_mid));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry_mid), .S(S[7:4]), .Cout(Gg));
    
    // Block propagate is true only if both 4-bit blocks propagate
    assign Pg = ((A[3:0] ^ B[3:0]) == 4'b1111) && ((A[7:4] ^ B[7:4]) == 4'b1111);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Segment the adder into 4x8-bit blocks with carry-select
    wire [3:0] Pg, Gg;
    wire [3:0] carry_pred;
    wire [3:0] carry_actual;
    
    // Generate carry predictions for all segments
    assign carry_pred[0] = 1'b0;  // First segment always starts with 0
    assign carry_pred[1] = Gg[0] | (Pg[0] & carry_pred[0]);
    assign carry_pred[2] = Gg[1] | (Pg[1] & carry_pred[1]);
    assign carry_pred[3] = Gg[2] | (Pg[2] & carry_pred[2]);
    
    // Instantiate 8-bit CLA blocks with predicted carries
    cla_8bit seg0 (.A(A[8:1]), .B(B[8:1]), .Cin(carry_pred[0]), .S(S[8:1]), .Pg(Pg[0]), .Gg(Gg[0]));
    cla_8bit seg1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry_pred[1]), .S(S[16:9]), .Pg(Pg[1]), .Gg(Gg[1]));
    cla_8bit seg2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry_pred[2]), .S(S[24:17]), .Pg(Pg[2]), .Gg(Gg[2]));
    cla_8bit seg3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry_pred[3]), .S(S[32:25]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Final carry out
    assign C32 = Gg[3] | (Pg[3] & carry_pred[3]);
endmodule