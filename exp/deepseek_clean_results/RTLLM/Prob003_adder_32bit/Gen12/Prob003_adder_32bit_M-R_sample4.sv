module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign S = P ^ C;
    assign Pg = &P;  // Group propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg
);
    wire [3:0] p_group, g_group;
    wire [3:0] carry;
    
    cla_4bit block0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Pg(p_group[0]), .Gg(g_group[0]));
    cla_4bit block1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .Pg(p_group[1]), .Gg(g_group[1]));
    cla_4bit block2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), .Pg(p_group[2]), .Gg(g_group[2]));
    cla_4bit block3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), .Pg(p_group[3]), .Gg(g_group[3]));
    
    // Block carry computation
    assign carry[0] = g_group[0] | (p_group[0] & Cin);
    assign carry[1] = g_group[1] | (p_group[1] & g_group[0]) | (p_group[1] & p_group[0] & Cin);
    assign carry[2] = g_group[2] | (p_group[2] & g_group[1]) | (p_group[2] & p_group[1] & g_group[0]) | 
                     (p_group[2] & p_group[1] & p_group[0] & Cin);
    
    // Group propagate/generate
    assign Pg = &p_group;
    assign Gg = g_group[3] | (p_group[3] & g_group[2]) | (p_group[3] & p_group[2] & g_group[1]) | 
               (p_group[3] & p_group[2] & p_group[1] & g_group[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire p_high, g_high;
    wire carry_mid;
    
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Pg(), .Gg());
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(carry_mid), .S(S[32:17]), .Pg(p_high), .Gg(g_high));
    
    // Intermediate carry computation
    assign carry_mid = low.Gg | (low.Pg & 1'b0);
    assign C32 = g_high | (p_high & carry_mid);
endmodule