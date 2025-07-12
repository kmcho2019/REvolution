module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Optimized carry lookahead logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Block-level generate and propagate
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_out = &P;
    
    assign S = P ^ C;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // First-level lookahead
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .G_out(G[0]), .P_out(P[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .G_out(G[1]), .P_out(P[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), .G_out(G[2]), .P_out(P[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), .G_out(G[3]), .P_out(P[3]));
    
    // Second-level lookahead
    assign carry[0] = G[0] | (P[0] & Cin);
    assign carry[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign carry[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    
    // Block-level outputs
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_out = &P;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G_low, P_low, G_high, P_high;
    wire C16;
    
    // Second-level lookahead for 32-bit adder
    assign C16 = G_low | (P_low & 1'b0);
    assign C32 = G_high | (P_high & G_low);
    
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .G_out(G_low), 
        .P_out(P_low)
    );
    
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .G_out(G_high), 
        .P_out(P_high)
    );
endmodule