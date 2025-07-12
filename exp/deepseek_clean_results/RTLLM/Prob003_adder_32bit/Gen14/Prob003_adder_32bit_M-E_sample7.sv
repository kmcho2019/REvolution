module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Bit-level propagate and generate
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;
    
    // 4-bit group PG
    wire P0_3 = &P[3:0];
    wire G0_3 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    
    wire P4_7 = &P[7:4];
    wire G4_7 = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    
    // Block carries
    wire C4 = G0_3 | (P0_3 & Cin);
    wire C8 = G4_7 | (P4_7 & C4);
    
    // Intermediate carries
    wire [7:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = C4;
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    
    assign S = P ^ C;
    assign Cout = C8;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [1:0] carry;
    
    cla_8bit cla0 (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), .S(S[7:0]), .Cout(carry[0]));
    cla_8bit cla1 (.A(A[15:8]), .B(B[15:8]), .Cin(carry[0]), .S(S[15:8]), .Cout(carry[1]));
    
    assign Cout = carry[1];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [1:0] carry;
    wire [15:0] low_sum, high_sum;
    
    // Conditional carry bypass
    wire low_zero = ~(|A[16:1] | |B[16:1]);
    
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(low_sum),
        .Cout(carry[0])
    );
    
    assign S[16:1] = low_zero ? (A[16:1] ^ B[16:1]) : low_sum;
    
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(low_zero ? 1'b0 : carry[0]),
        .S(high_sum),
        .Cout(carry[1])
    );
    
    assign S[32:17] = high_sum;
    assign C32 = low_zero ? 1'b0 : carry[1];
endmodule