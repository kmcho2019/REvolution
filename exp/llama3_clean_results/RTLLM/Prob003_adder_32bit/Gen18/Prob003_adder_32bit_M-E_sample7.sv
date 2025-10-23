// Radix-4 Carry-Save Adder Block
module radix4_csa(
    input [7:0] A,
    input [7:0] B,
    input [7:0] C_in,
    output [7:0] S,
    output [7:0] C_out
);

    assign S = A + B + C_in;
    assign C_out = (A & B) | (A & C_in) | (B & C_in);

endmodule

// Carry-Lookahead Logic
module cla_logic(
    input [7:0] C_in,
    output [7:0] C_out
);

    assign C_out[0] = C_in[0];
    for (genvar i = 1; i <= 7; i++) begin
        assign C_out[i] = C_in[i] | (C_in[i-1] & (C_in[i] | C_in[i-1]));
    end

endmodule

// Hybrid Carry-Save and Carry-Lookahead Adder (HCCLA)
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [7:0] S1, S2, S3, S4;
    wire [7:0] C1, C2, C3;
    wire C_out;

    radix4_csa u1(
       .A(A[8:1]),
       .B(B[8:1]),
       .C_in(8'd0),
       .S(S1),
       .C_out(C1)
    );

    radix4_csa u2(
       .A(A[16:9]),
       .B(B[16:9]),
       .C_in(C1),
       .S(S2),
       .C_out(C2)
    );

    radix4_csa u3(
       .A(A[24:17]),
       .B(B[24:17]),
       .C_in(C2),
       .S(S3),
       .C_out(C3)
    );

    radix4_csa u4(
       .A(A[32:25]),
       .B(B[32:25]),
       .C_in(C3),
       .S(S4),
       .C_out(C_out)
    );

    cla_logic u5(
       .C_in(C_out),
       .C_out(C32)
    );

    assign S[8:1] = S1;
    assign S[16:9] = S2;
    assign S[24:17] = S3;
    assign S[32:25] = S4;

endmodule