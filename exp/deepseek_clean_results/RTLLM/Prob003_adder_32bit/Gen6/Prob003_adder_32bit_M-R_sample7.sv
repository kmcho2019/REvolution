module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Generate and Propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Carry computation - unrolled equations
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
              (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    
    assign Cout = C4;
    assign S = P ^ {C3, C2, C1, Cin};
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // Block Generate and Propagate terms
    wire [3:0] G_block, P_block;
    wire [3:0] carry;
    
    // Instantiate 4-bit CLAs and compute block G/P
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                .S(S[3:0]), .Cout(carry[0]));
    assign G_block[0] = (A[3:0] & B[3:0]) == 4'b1111;
    assign P_block[0] = (A[3:0] ^ B[3:0]) == 4'b1111;
    
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), 
                .S(S[7:4]), .Cout(carry[1]));
    assign G_block[1] = (A[7:4] & B[7:4]) == 4'b1111;
    assign P_block[1] = (A[7:4] ^ B[7:4]) == 4'b1111;
    
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), 
                .S(S[11:8]), .Cout(carry[2]));
    assign G_block[2] = (A[11:8] & B[11:8]) == 4'b1111;
    assign P_block[2] = (A[11:8] ^ B[11:8]) == 4'b1111;
    
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), 
                .S(S[15:12]), .Cout(carry[3]));
    assign G_block[3] = (A[15:12] & B[15:12]) == 4'b1111;
    assign P_block[3] = (A[15:12] ^ B[15:12]) == 4'b1111;
    
    // Final carry out
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Direct hierarchical instantiation
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C32)  // Connect directly to output
    );
    
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C32),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule