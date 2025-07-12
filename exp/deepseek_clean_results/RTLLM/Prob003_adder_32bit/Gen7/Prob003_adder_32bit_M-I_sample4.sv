module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Generate and Propagate terms
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // Carry computation using Brent-Kung structure
    wire [7:0] C;
    wire [3:0] G1, P1;
    wire [1:0] G2, P2;
    
    // First level
    assign C[0] = Cin;
    assign G1[0] = G[0] | (P[0] & C[0]);
    assign P1[0] = P[0];
    
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : first_level
            assign G1[i] = G[2*i] | (P[2*i] & G[2*i-1]);
            assign P1[i] = P[2*i] & P[2*i-1];
        end
    endgenerate
    
    // Second level
    assign G2[0] = G1[0] | (P1[0] & G1[1]);
    assign P2[0] = P1[0] & P1[1];
    assign G2[1] = G1[2] | (P1[2] & G1[3]);
    assign P2[1] = P1[2] & P1[3];
    
    // Final carry computation
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G1[1] | (P1[1] & C[0]);
    assign C[4] = G2[0] | (P2[0] & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G1[2] | (P1[2] & C[4]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign Cout = G2[1] | (P2[1] & C[4]);
    
    // Sum computation
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    cla_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(carry[0]));
    cla_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[0]), .S(S[16:9]), .Cout(carry[1]));
    cla_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), .Cout(carry[2]));
    cla_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), .Cout(carry[3]));
    
    assign C32 = carry[3];
endmodule