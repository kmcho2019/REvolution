// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire [4:1] G, P;
    wire [3:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= 4; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values
    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[4] + (P[4] & C[3]);

    // Calculate S values
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end
endmodule

// Tree-like carry propagation module
module carry_prop(
    input [7:0] C_in,
    output [3:0] C_out
);
    wire [3:0] C_mid;

    // First level of carry propagation
    assign C_out[0] = C_in[0] | C_in[1];
    assign C_out[1] = C_in[2] | C_in[3];
    assign C_out[2] = C_in[4] | C_in[5];
    assign C_out[3] = C_in[6] | C_in[7];

    // Second level of carry propagation
    assign C_mid[0] = C_out[0] | C_out[1];
    assign C_mid[1] = C_out[2] | C_out[3];

    // Final level of carry propagation
    assign C_out[0] = C_mid[0];
    assign C_out[1] = C_mid[1];
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] C_in;
    wire [3:0] C_out;
    wire [31:1] S_temp;

    // 4-bit CLA blocks
    cla_4bit u1(
      .A(A[4:1]),
      .B(B[4:1]),
      .C_in(1'b0),
      .S(S[4:1]),
      .C_out(C_in[0])
    );

    cla_4bit u2(
      .A(A[8:5]),
      .B(B[8:5]),
      .C_in(C_in[0]),
      .S(S[8:5]),
      .C_out(C_in[1])
    );

    cla_4bit u3(
      .A(A[12:9]),
      .B(B[12:9]),
      .C_in(C_in[1]),
      .S(S[12:9]),
      .C_out(C_in[2])
    );

    cla_4bit u4(
      .A(A[16:13]),
      .B(B[16:13]),
      .C_in(C_in[2]),
      .S(S[16:13]),
      .C_out(C_in[3])
    );

    cla_4bit u5(
      .A(A[20:17]),
      .B(B[20:17]),
      .C_in(C_in[3]),
      .S(S[20:17]),
      .C_out(C_in[4])
    );

    cla_4bit u6(
      .A(A[24:21]),
      .B(B[24:21]),
      .C_in(C_in[4]),
      .S(S[24:21]),
      .C_out(C_in[5])
    );

    cla_4bit u7(
      .A(A[28:25]),
      .B(B[28:25]),
      .C_in(C_in[5]),
      .S(S[28:25]),
      .C_out(C_in[6])
    );

    cla_4bit u8(
      .A(A[32:29]),
      .B(B[32:29]),
      .C_in(C_in[6]),
      .S(S[32:29]),
      .C_out(C_in[7])
    );

    // Tree-like carry propagation
    carry_prop u9(
      .C_in(C_in),
      .C_out(C_out)
    );

    // Final level of carry propagation
    assign C32 = C_out[3];
endmodule