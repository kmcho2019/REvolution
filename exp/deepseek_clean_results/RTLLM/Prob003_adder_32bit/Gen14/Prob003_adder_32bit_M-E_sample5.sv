module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign Cout = G[7] | (P[7] & C[7]);
    
    assign S = P ^ C;
endmodule

module segment_8bit (
    input [7:0] A,
    input [7:0] B,
    output [7:0] S0,  // Sum with Cin=0
    output [7:0] S1,  // Sum with Cin=1
    output C0,       // Cout with Cin=0
    output C1        // Cout with Cin=1
);
    cla_8bit cla0 (.A(A), .B(B), .Cin(1'b0), .S(S0), .Cout(C0));
    cla_8bit cla1 (.A(A), .B(B), .Cin(1'b1), .S(S1), .Cout(C1));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Segment outputs
    wire [7:0] S0_0, S0_1, S1_0, S1_1, S2_0, S2_1, S3_0, S3_1;
    wire C0_0, C0_1, C1_0, C1_1, C2_0, C2_1, C3_0, C3_1;
    
    // Instantiate all segments
    segment_8bit seg0 (.A(A[8:1]), .B(B[8:1]), .S0(S0_0), .S1(S0_1), .C0(C0_0), .C1(C0_1));
    segment_8bit seg1 (.A(A[16:9]), .B(B[16:9]), .S0(S1_0), .S1(S1_1), .C0(C1_0), .C1(C1_1));
    segment_8bit seg2 (.A(A[24:17]), .B(B[24:17]), .S0(S2_0), .S1(S2_1), .C0(C2_0), .C1(C2_1));
    segment_8bit seg3 (.A(A[32:25]), .B(B[32:25]), .S0(S3_0), .S1(S3_1), .C0(C3_0), .C1(C3_1));
    
    // Hierarchical carry lookahead
    wire C8, C16, C24;
    
    // First segment carry is 0
    assign C8 = C0_0;
    assign S[8:1] = S0_0;
    
    // Second segment mux
    assign C16 = C8 ? C1_1 : C1_0;
    assign S[16:9] = C8 ? S1_1 : S1_0;
    
    // Third segment mux
    assign C24 = C16 ? C2_1 : C2_0;
    assign S[24:17] = C16 ? S2_1 : S2_0;
    
    // Fourth segment mux
    assign C32 = C24 ? C3_1 : C3_0;
    assign S[32:25] = C24 ? S3_1 : S3_0;
endmodule