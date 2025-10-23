module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P
);
    wire [3:0] G_wire, P_wire, C_wire;
    
    // Generate (G) and Propagate (P) terms
    assign G_wire = A & B;
    assign P_wire = A ^ B;
    
    // Carry calculation
    assign C_wire[0] = Cin;
    assign C_wire[1] = G_wire[0] | (P_wire[0] & C_wire[0]);
    assign C_wire[2] = G_wire[1] | (P_wire[1] & G_wire[0]) | (P_wire[1] & P_wire[0] & C_wire[0]);
    assign C_wire[3] = G_wire[2] | (P_wire[2] & G_wire[1]) | (P_wire[2] & P_wire[1] & G_wire[0]) | 
                       (P_wire[2] & P_wire[1] & P_wire[0] & C_wire[0]);
    
    // Sum calculation
    assign S = P_wire ^ C_wire;
    
    // Block Generate and Propagate
    assign G = G_wire[3] | (P_wire[3] & G_wire[2]) | (P_wire[3] & P_wire[2] & G_wire[1]) | 
               (P_wire[3] & P_wire[2] & P_wire[1] & G_wire[0]);
    assign P = P_wire[3] & P_wire[2] & P_wire[1] & P_wire[0];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire [4:1] C;
    
    // First 4-bit CLA
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .G(G[0]),
        .P(P[0])
    );
    
    // Carry between 4-bit blocks
    assign C[1] = G[0] | (P[0] & Cin);
    
    // Second 4-bit CLA
    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[1]),
        .S(S[7:4]),
        .G(G[1]),
        .P(P[1])
    );
    
    // Carry between 4-bit blocks
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    
    // Third 4-bit CLA
    cla_4bit cla2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[2]),
        .S(S[11:8]),
        .G(G[2]),
        .P(P[2])
    );
    
    // Carry between 4-bit blocks
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    
    // Fourth 4-bit CLA
    cla_4bit cla3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[3]),
        .S(S[15:12]),
        .G(G[3]),
        .P(P[3])
    );
    
    // Final carry out
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    // First 16-bit CLA (bits 1-16)
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    // Second 16-bit CLA (bits 17-32)
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule