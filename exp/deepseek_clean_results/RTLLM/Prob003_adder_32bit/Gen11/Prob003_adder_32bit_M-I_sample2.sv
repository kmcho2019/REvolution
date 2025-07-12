module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_group,
    output P_group
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Group propagate/generate
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_group = P[3] & P[2] & P[1] & P[0];
    
    // Carry lookahead
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    // Sum calculation with optimized XOR
    assign S = P ^ {C[2:0], Cin};
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G_group, P_group;
    wire [3:0] carry;
    
    // Second-level lookahead
    assign carry[0] = Cin;
    assign carry[1] = G_group[0] | (P_group[0] & carry[0]);
    assign carry[2] = G_group[1] | (P_group[1] & carry[1]);
    assign carry[3] = G_group[2] | (P_group[2] & carry[2]);
    assign Cout = G_group[3] | (P_group[3] & carry[3]);
    
    // 4-bit blocks with hierarchical lookahead
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(carry[0]), .S(S[3:0]), 
                  .G_group(G_group[0]), .P_group(P_group[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[1]), .S(S[7:4]), 
                  .G_group(G_group[1]), .P_group(P_group[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[2]), .S(S[11:8]), 
                  .G_group(G_group[2]), .P_group(P_group[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[3]), .S(S[15:12]), 
                  .G_group(G_group[3]), .P_group(P_group[3]));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G_low, P_low, C16;
    
    // First-level lookahead for 32-bit adder
    assign C16 = G_low | (P_low & 1'b0);
    
    // 16-bit blocks with hierarchical lookahead
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), 
                .Cout(G_low));
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), 
                 .Cout(C32));
    
    // Share P_low calculation between blocks
    assign P_low = &(A[16:1] ^ B[16:1]);
endmodule