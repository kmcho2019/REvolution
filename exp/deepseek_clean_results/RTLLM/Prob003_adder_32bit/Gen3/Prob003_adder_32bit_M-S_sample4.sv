module adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [4:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    
    // Sum computation
    assign S = P ^ C[3:0];
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg
);
    wire [3:0] Pg_4bit, Gg_4bit;
    wire [4:0] C;
    
    assign C[0] = Cin;
    
    // Instantiate four 4-bit CLAs
    adder_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(C[0]), .S(S[3:0]), .Pg(Pg_4bit[0]), .Gg(Gg_4bit[0]));
    adder_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(Pg_4bit[1]), .Gg(Gg_4bit[1]));
    adder_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(C[2]), .S(S[11:8]), .Pg(Pg_4bit[2]), .Gg(Gg_4bit[2]));
    adder_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .Pg(Pg_4bit[3]), .Gg(Gg_4bit[3]));
    
    // Carry lookahead logic
    assign C[1] = Gg_4bit[0] | (Pg_4bit[0] & C[0]);
    assign C[2] = Gg_4bit[1] | (Pg_4bit[1] & C[1]);
    assign C[3] = Gg_4bit[2] | (Pg_4bit[2] & C[2]);
    assign C[4] = Gg_4bit[3] | (Pg_4bit[3] & C[3]);
    
    // Group propagate and generate
    assign Pg = &Pg_4bit;
    assign Gg = Gg_4bit[3] | (Pg_4bit[3] & Gg_4bit[2]) | (Pg_4bit[3] & Pg_4bit[2] & Gg_4bit[1]) | 
                (Pg_4bit[3] & Pg_4bit[2] & Pg_4bit[1] & Gg_4bit[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [1:0] Pg_16bit, Gg_16bit;
    wire [2:0] C;
    
    assign C[0] = 1'b0;
    
    // Instantiate two 16-bit CLAs
    adder_16bit cla0 (.A(A[16:1]), .B(B[16:1]), .Cin(C[0]), .S(S[16:1]), .Pg(Pg_16bit[0]), .Gg(Gg_16bit[0]));
    adder_16bit cla1 (.A(A[32:17]), .B(B[32:17]), .Cin(C[1]), .S(S[32:17]), .Pg(Pg_16bit[1]), .Gg(Gg_16bit[1]));
    
    // Carry lookahead logic
    assign C[1] = Gg_16bit[0] | (Pg_16bit[0] & C[0]);
    assign C[2] = Gg_16bit[1] | (Pg_16bit[1] & C[1]);
    
    assign C32 = C[2];
endmodule