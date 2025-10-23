// 4-bit Carry-Lookahead Adder with Carry Prediction
module cla_4bit_pred(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out,
    output pred_match
);

    wire [3:1] C;
    wire [3:1] G; // Generate signal
    wire [3:1] P; // Propagate signal

    // Calculate generate and propagate signals
    for (genvar i = 1; i <= 3; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Calculate carry signals
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[3] | (P[3] & C[2]);

    // Calculate sum signals
    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 3; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

    // Carry prediction mechanism
    wire pred_carry;
    assign pred_carry = (A[3] & B[3]) | (A[3] & A[2] & B[2]) | (B[3] & A[2] & B[2]);
    assign pred_match = (pred_carry == C_out);

endmodule

// 8-bit Carry-Lookahead Adder with Dynamic Carry Bypassing
module cla_8bit_bypass(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire C4;
    wire bypass;

    cla_4bit_pred u1(
      .A(A[4:1]),
      .B(B[4:1]),
      .C_in(C_in),
      .S(S[4:1]),
      .C_out(C4),
      .pred_match(bypass)
    );

    cla_4bit_pred u2(
      .A(A[8:5]),
      .B(B[8:5]),
      .C_in(bypass ? 1'b0 : C4),
      .S(S[8:5]),
      .C_out(C_out),
      .pred_match()
    );

endmodule

// 32-bit Hybrid Parallelized Carry-Lookahead Adder
module adder_32bit_hybrid(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [4:1] C8;

    // Parallelized 8-bit adder blocks
    for (genvar i = 0; i < 4; i++) begin
        cla_8bit_bypass u(
          .A(A[(i*8)+8: (i*8)+1]),
          .B(B[(i*8)+8: (i*8)+1]),
          .C_in(i == 0 ? 1'b0 : C8[i-1]),
          .S(S[(i*8)+8: (i*8)+1]),
          .C_out(C8[i])
        );
    end

    assign C32 = C8[3];

endmodule