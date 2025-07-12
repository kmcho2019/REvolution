// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [3:1] C;

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign C_out = A[4] & B[4] | (A[4] ^ B[4]) & C[3];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// Generic CLA module using generate
module cla_generic(
    input [31:1] A,
    input [31:1] B,
    input C_in,
    output [31:1] S,
    output C_out
);

    wire [16:1] C8;
    wire [8:1] C4;

    genvar i;
    generate
        for (i = 1; i <= 8; i++) begin
            cla_4bit u1(
               .A(A[(i*4):((i-1)*4+1)]),
               .B(B[(i*4):((i-1)*4+1)]),
               .C_in(i == 1? C_in : C4[i-1]),
               .S(S[(i*4):((i-1)*4+1)]),
               .C_out(C4[i])
            );
        end
    endgenerate

    assign C_out = C4[8];

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] C16;
    wire [16:1] S1, S2;

    cla_generic u1(
       .A(A[16:1]),
       .B(B[16:1]),
       .C_in(1'b0),
       .S(S1),
       .C_out(C16[1])
    );

    cla_generic u2(
       .A(A[32:17]),
       .B(B[32:17]),
       .C_in(C16[1]),
       .S(S2),
       .C_out(C32)
    );

    assign S[16:1] = S1;
    assign S[32:17] = S2;

endmodule