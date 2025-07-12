module cla_4bit_shared (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input en,
    output [3:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G = en ? (A & B) : 4'b0;
    wire [3:0] P = en ? (A ^ B) : 4'b0;
    wire [3:0] C;
    
    // Block-level propagate/generate
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_out = &P;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign S = P ^ C;
endmodule

module cla_16bit_optimized (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    input en,
    output [15:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G_block, P_block;
    wire [3:0] carry;
    
    // Generate carry using second-level lookahead
    assign carry[0] = Cin;
    assign carry[1] = G_block[0] | (P_block[0] & carry[0]);
    assign carry[2] = G_block[1] | (P_block[1] & carry[1]);
    assign carry[3] = G_block[2] | (P_block[2] & carry[2]);
    
    cla_4bit_shared cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(carry[0]), .en(en), 
                         .S(S[3:0]), .G_out(G_block[0]), .P_out(P_block[0]));
    cla_4bit_shared cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[1]), .en(en),
                         .S(S[7:4]), .G_out(G_block[1]), .P_out(P_block[1]));
    cla_4bit_shared cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[2]), .en(en),
                         .S(S[11:8]), .G_out(G_block[2]), .P_out(P_block[2]));
    cla_4bit_shared cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[3]), .en(en),
                         .S(S[15:12]), .G_out(G_block[3]), .P_out(P_block[3]));
    
    // Block-level propagate/generate
    assign G_out = G_block[3] | (P_block[3] & G_block[2]) | 
                  (P_block[3] & P_block[2] & G_block[1]) | 
                  (P_block[3] & P_block[2] & P_block[1] & G_block[0]);
    assign P_out = &P_block;
endmodule

module adder_32bit_optimized (
    input [32:1] A,
    input [32:1] B,
    input en,
    output [32:1] S,
    output C32
);
    wire G_low, P_low;
    wire C16;
    
    // Second-level carry lookahead
    assign C16 = G_low | (P_low & 1'b0);
    
    cla_16bit_optimized low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .en(en),
                        .S(S[16:1]), .G_out(G_low), .P_out(P_low));
    cla_16bit_optimized high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .en(en),
                         .S(S[32:17]), .G_out(), .P_out(), .Cout(C32));
endmodule