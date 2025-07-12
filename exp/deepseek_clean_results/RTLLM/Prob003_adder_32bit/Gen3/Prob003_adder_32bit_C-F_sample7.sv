module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] P, G;
    wire [8:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Kogge-Stone parallel prefix carry computation
    // First level
    wire [7:0] G1, P1;
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : first_level
            assign G1[i] = G[i] | (P[i] & G[i-1]);
            assign P1[i] = P[i] & P[i-1];
        end
    endgenerate
    
    // Second level
    wire [7:0] G2, P2;
    assign G2[1:0] = G1[1:0];
    assign P2[1:0] = P1[1:0];
    generate
        for (i = 2; i < 8; i = i + 1) begin : second_level
            assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
            assign P2[i] = P1[i] & P1[i-2];
        end
    endgenerate
    
    // Third level
    wire [7:0] G3, P3;
    assign G3[3:0] = G2[3:0];
    assign P3[3:0] = P2[3:0];
    generate
        for (i = 4; i < 8; i = i + 1) begin : third_level
            assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
            assign P3[i] = P2[i] & P2[i-4];
        end
    endgenerate
    
    // Final carry computation
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    assign C[4] = G3[3] | (P3[3] & C[0]);
    assign C[5] = G3[4] | (P3[4] & C[0]);
    assign C[6] = G3[5] | (P3[5] & C[0]);
    assign C[7] = G3[6] | (P3[6] & C[0]);
    assign C[8] = G3[7] | (P3[7] & C[0]);
    
    // Sum computation
    assign S = P ^ C[7:0];
    assign Cout = C[8];
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