module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Generate and propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Carry computation
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Output assignments
    assign S = P ^ {C3, C2, C1, C0};
    assign Cout = C4;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // Intermediate carries between 4-bit blocks
    wire carry0, carry1, carry2;
    
    // Instantiate 4-bit CLAs with explicit carry chaining
    cla_4bit block0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(Cin),    .S(S[3:0]),   .Cout(carry0));
    cla_4bit block1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(carry0), .S(S[7:4]),   .Cout(carry1));
    cla_4bit block2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(carry1), .S(S[11:8]),  .Cout(carry2));
    cla_4bit block3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry2), .S(S[15:12]), .Cout(Cout));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Intermediate carry between 16-bit blocks
    wire mid_carry;
    
    // Lower 16 bits
    cla_16bit lower_adder (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(mid_carry)
    );
    
    // Upper 16 bits
    cla_16bit upper_adder (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(mid_carry),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule