// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    reg [4:1] S_reg;
    reg C_out_reg;
    reg [3:1] C;

    integer i;
    always @(*) begin
        C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
        for (i = 2; i <= 3; i++) begin
            C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
        end
        C_out_reg = A[4] & B[4] | (A[4] ^ B[4]) & C[3];

        S_reg[1] = A[1] ^ B[1] ^ C_in;
        for (i = 2; i <= 4; i++) begin
            S_reg[i] = A[i] ^ B[i] ^ C[i-1];
        end
    end

    assign S = S_reg;
    assign C_out = C_out_reg;

endmodule

// Tree Node
module tree_node(
    input C_in1,
    input C_in2,
    output C_out
);
    assign C_out = C_in1 | C_in2;

endmodule

// 32-bit Tree-Based Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] C;

    cla_4bit u1(
       .A(A[4:1]),
       .B(B[4:1]),
       .C_in(1'b0),
       .S(S[4:1]),
       .C_out(C[1])
    );

    cla_4bit u2(
       .A(A[8:5]),
       .B(B[8:5]),
       .C_in(C[1]),
       .S(S[8:5]),
       .C_out(C[2])
    );

    cla_4bit u3(
       .A(A[12:9]),
       .B(B[12:9]),
       .C_in(C[2]),
       .S(S[12:9]),
       .C_out(C[3])
    );

    cla_4bit u4(
       .A(A[16:13]),
       .B(B[16:13]),
       .C_in(C[3]),
       .S(S[16:13]),
       .C_out(C[4])
    );

    cla_4bit u5(
       .A(A[20:17]),
       .B(B[20:17]),
       .C_in(C[4]),
       .S(S[20:17]),
       .C_out(C[5])
    );

    cla_4bit u6(
       .A(A[24:21]),
       .B(B[24:21]),
       .C_in(C[5]),
       .S(S[24:21]),
       .C_out(C[6])
    );

    cla_4bit u7(
       .A(A[28:25]),
       .B(B[28:25]),
       .C_in(C[6]),
       .S(S[28:25]),
       .C_out(C[7])
    );

    cla_4bit u8(
       .A(A[32:29]),
       .B(B[32:29]),
       .C_in(C[7]),
       .S(S[32:29]),
       .C_out(C32)
    );

    tree_node tn1(
       .C_in1(C[1]),
       .C_in2(C[2]),
       .C_out(C[3])
    );

    tree_node tn2(
       .C_in1(C[3]),
       .C_in2(C[4]),
       .C_out(C[5])
    );

    tree_node tn3(
       .C_in1(C[5]),
       .C_in2(C[6]),
       .C_out(C[7])
    );

endmodule