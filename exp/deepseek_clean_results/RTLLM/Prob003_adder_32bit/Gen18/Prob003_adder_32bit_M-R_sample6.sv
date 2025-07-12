module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Generate and propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Brent-Kung parallel prefix carry computation
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Sum and carry outputs
    assign S = P ^ C;
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // 4-bit CLA instances with direct wiring
    wire [3:0] carry;
    
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(carry[0])
    );
    
    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry[0]),
        .S(S[7:4]),
        .Cout(carry[1])
    );
    
    cla_4bit cla2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(carry[1]),
        .S(S[11:8]),
        .Cout(carry[2])
    );
    
    cla_4bit cla3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(carry[2]),
        .S(S[15:12]),
        .Cout(carry[3])
    );
    
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // 16-bit CLA blocks with direct carry chaining
    wire mid_carry;
    
    cla_16bit low_16bit (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(mid_carry)
    );
    
    cla_16bit high_16bit (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(mid_carry),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule