// Generic N-bit Carry-Lookahead Adder
module cla_nbit #(
    parameter WIDTH = 4
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input C_in,
    output [WIDTH-1:0] S,
    output C_out
);
    wire [WIDTH-1:0] G, P;
    wire [WIDTH-2:0] C;

    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            G[i] = A[i] & B[i];
            P[i] = A[i] ^ B[i];
        end

        C[0] = G[0] + (P[0] & C_in);
        C_out = G[WIDTH-1] + (P[WIDTH-1] & C[WIDTH-2]);
        for (int i = 1; i < WIDTH-1; i++) begin
            C[i] = G[i] + (P[i] & C[i-1]);
        end

        for (int i = 0; i < WIDTH; i++) begin
            S[i] = P[i] ^ (i == 0) ? C_in : C[i-1];
        end
    end
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_nbit #(.WIDTH(16)) u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );
    cla_nbit #(.WIDTH(16)) u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );
endmodule