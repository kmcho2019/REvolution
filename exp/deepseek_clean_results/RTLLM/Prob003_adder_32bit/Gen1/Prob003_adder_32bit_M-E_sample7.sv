module adder_2bit (
    input [1:0] A,
    input [1:0] B,
    input Cin,
    output [1:0] S,
    output G,
    output P
);
    wire [1:0] G_wire, P_wire;
    
    // Generate and Propagate signals
    assign G_wire = A & B;
    assign P_wire = A ^ B;
    
    // Sum calculation
    assign S[0] = P_wire[0] ^ Cin;
    assign S[1] = P_wire[1] ^ (G_wire[0] | (P_wire[0] & Cin));
    
    // Block Generate and Propagate
    assign G = G_wire[1] | (P_wire[1] & G_wire[0]);
    assign P = P_wire[1] & P_wire[0];
endmodule

module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire [3:0] C;
    
    // Instantiate four 2-bit CLA blocks
    adder_2bit cla0 (.A(A[1:0]), .B(B[1:0]), .Cin(Cin), .S(S[1:0]), .G(G[0]), .P(P[0]));
    adder_2bit cla1 (.A(A[3:2]), .B(B[3:2]), .Cin(C[0]), .S(S[3:2]), .G(G[1]), .P(P[1]));
    adder_2bit cla2 (.A(A[5:4]), .B(B[5:4]), .Cin(C[1]), .S(S[5:4]), .G(G[2]), .P(P[2]));
    adder_2bit cla3 (.A(A[7:6]), .B(B[7:6]), .Cin(C[2]), .S(S[7:6]), .G(G[3]), .P(P[3]));
    
    // Carry lookahead logic between 2-bit blocks
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
    
    assign Cout = C[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G, P;
    wire [3:0] C;
    
    // Instantiate four 8-bit CLA blocks
    adder_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout());
    adder_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(C[0]), .S(S[16:9]), .Cout());
    adder_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(C[1]), .S(S[24:17]), .Cout());
    adder_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(C[2]), .S(S[32:25]), .Cout());
    
    // Generate and Propagate signals from each 8-bit block
    // These would come from the last 2-bit block in each 8-bit block
    assign G[0] = (A[8] & B[8]) | ((A[8] ^ B[8]) & (A[7] & B[7]));
    assign P[0] = (A[8] ^ B[8]) & (A[7] ^ B[7]);
    
    assign G[1] = (A[16] & B[16]) | ((A[16] ^ B[16]) & (A[15] & B[15]));
    assign P[1] = (A[16] ^ B[16]) & (A[15] ^ B[15]);
    
    assign G[2] = (A[24] & B[24]) | ((A[24] ^ B[24]) & (A[23] & B[23]));
    assign P[2] = (A[24] ^ B[24]) & (A[23] ^ B[23]);
    
    assign G[3] = (A[32] & B[32]) | ((A[32] ^ B[32]) & (A[31] & B[31]));
    assign P[3] = (A[32] ^ B[32]) & (A[31] ^ B[31]);
    
    // Top-level carry lookahead logic
    assign C[0] = G[0] | (P[0] & 1'b0);
    assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & 1'b0);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & 1'b0);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & 1'b0);
    
    assign C32 = C[3];
endmodule