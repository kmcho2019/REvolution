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

module hcsl_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Carry=0 path
    wire [7:0] S0;
    wire Cout0_lo, Cout0_hi;
    cla_4bit cla0_0 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S0[3:0]), .Cout(Cout0_lo));
    cla_4bit cla0_1 (.A(A[7:4]), .B(B[7:4]), .Cin(Cout0_lo), .S(S0[7:4]), .Cout(Cout0_hi));
    
    // Carry=1 path
    wire [7:0] S1;
    wire Cout1_lo, Cout1_hi;
    cla_4bit cla1_0 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b1), .S(S1[3:0]), .Cout(Cout1_lo));
    cla_4bit cla1_1 (.A(A[7:4]), .B(B[7:4]), .Cin(Cout1_lo), .S(S1[7:4]), .Cout(Cout1_hi));
    
    // Select correct path
    assign S = Cin ? S1 : S0;
    assign Cout = Cin ? Cout1_hi : Cout0_hi;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] segment_carry;
    
    hcsl_8bit seg0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(segment_carry[0]));
    hcsl_8bit seg1 (.A(A[16:9]), .B(B[16:9]), .Cin(segment_carry[0]), .S(S[16:9]), .Cout(segment_carry[1]));
    hcsl_8bit seg2 (.A(A[24:17]), .B(B[24:17]), .Cin(segment_carry[1]), .S(S[24:17]), .Cout(segment_carry[2]));
    hcsl_8bit seg3 (.A(A[32:25]), .B(B[32:25]), .Cin(segment_carry[2]), .S(S[32:25]), .Cout(segment_carry[3]));
    
    assign C32 = segment_carry[3];
endmodule