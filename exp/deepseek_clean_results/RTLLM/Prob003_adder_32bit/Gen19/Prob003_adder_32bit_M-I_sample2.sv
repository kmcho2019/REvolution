module cla_4bit_manchester (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Manchester carry chain implementation
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Carry chain using pass transistors
    assign C[0] = Cin;
    assign C[1] = G[0] ? 1'b1 : (P[0] ? C[0] : 1'b0);
    assign C[2] = G[1] ? 1'b1 : (P[1] ? C[1] : 1'b0);
    assign C[3] = G[2] ? 1'b1 : (P[2] ? C[2] : 1'b0);
    assign Cout = G[3] ? 1'b1 : (P[3] ? C[3] : 1'b0);
    
    // Sum generation with optimized XOR
    assign S = P ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Shared P/G generation for better area/power
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;
    
    wire c4;
    
    cla_4bit_manchester cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(c4));
    cla_4bit_manchester cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(c4),  .S(S[7:4]), .Cout(Cout));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire c8, c16, c24;
    
    cla_8bit block0 (.A(A[8:1]),   .B(B[8:1]),   .Cin(1'b0), .S(S[8:1]),   .Cout(c8));
    cla_8bit block1 (.A(A[16:9]),  .B(B[16:9]),  .Cin(c8),   .S(S[16:9]),  .Cout(c16));
    cla_8bit block2 (.A(A[24:17]), .B(B[24:17]), .Cin(c16),  .S(S[24:17]), .Cout(c24));
    cla_8bit block3 (.A(A[32:25]), .B(B[32:25]), .Cin(c24),  .S(S[32:25]), .Cout(C32));
endmodule