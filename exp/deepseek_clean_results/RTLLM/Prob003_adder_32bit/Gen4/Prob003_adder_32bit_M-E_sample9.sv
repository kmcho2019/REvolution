module csa_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] S0, S1;
    wire Cout0, Cout1;
    
    // Compute both possible sums (Cin=0 and Cin=1)
    assign {S0, Cout0} = A + B + 8'b0;
    assign {S1, Cout1} = A + B + 8'b1;
    
    // Select correct sum based on actual Cin
    assign S = Cin ? S1 : S0;
    
    // Block propagate/generate
    assign Pg = (A + B) == 8'hFF;  // All bits propagate
    assign Gg = Cout1;              // Block generates carry when Cin=1
endmodule

module lookahead_unit (
    input [3:0] Pg,
    input [3:0] Gg,
    input Cin,
    output [3:1] C
);
    // Carry lookahead between blocks
    assign C[1] = Gg[0] | (Pg[0] & Cin);
    assign C[2] = Gg[1] | (Pg[1] & C[1]);
    assign C[3] = Gg[2] | (Pg[2] & C[2]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg, Gg;
    wire [3:1] carry;
    
    // Instantiate lookahead unit
    lookahead_unit lau (
        .Pg(Pg[3:0]),
        .Gg(Gg[3:0]),
        .Cin(1'b0),
        .C(carry[3:1])
    );
    
    // 8-bit carry-select blocks
    csa_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Pg(Pg[0]),
        .Gg(Gg[0])
    );
    
    csa_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[1]),
        .S(S[16:9]),
        .Pg(Pg[1]),
        .Gg(Gg[1])
    );
    
    csa_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[2]),
        .S(S[24:17]),
        .Pg(Pg[2]),
        .Gg(Gg[2])
    );
    
    csa_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[3]),
        .S(S[32:25]),
        .Pg(Pg[3]),
        .Gg(Gg[3])
    );
    
    // Final carry out
    assign C32 = Gg[3] | (Pg[3] & carry[3]);
endmodule