module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
                 (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign S = P ^ C;
endmodule

module hcsla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire cout_low;
    wire [7:0] sum_high_c0, sum_high_c1;
    
    // Lower 4-bit (always calculated)
    cla_4bit lower (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(cout_low)
    );
    
    // Upper 4-bit (calculated for both carry possibilities)
    cla_4bit upper_c0 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(1'b0),
        .S(sum_high_c0[7:4]),
        .Cout(Cout_c0)
    );
    
    cla_4bit upper_c1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(1'b1),
        .S(sum_high_c1[7:4]),
        .Cout(Cout_c1)
    );
    
    // Carry-select muxes
    assign S[7:4] = cout_low ? sum_high_c1[7:4] : sum_high_c0[7:4];
    assign Cout = cout_low ? Cout_c1 : Cout_c0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    hcsla_8bit seg0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Cout(carry[0])
    );
    
    hcsla_8bit seg1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .Cout(carry[1])
    );
    
    hcsla_8bit seg2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .Cout(carry[2])
    );
    
    hcsla_8bit seg3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .Cout(carry[3])
    );
    
    assign C32 = carry[3];
endmodule