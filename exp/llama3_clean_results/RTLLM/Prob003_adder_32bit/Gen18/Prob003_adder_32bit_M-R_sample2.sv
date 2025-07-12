// Parametrized Carry-Lookahead Adder module
module cla #(
    parameter WIDTH = 4
)(
    input [WIDTH:1] A,
    input [WIDTH:1] B,
    input C_in,
    output [WIDTH:1] S,
    output C_out
);
    wire [WIDTH:1] G, P; // Generate and Propagate signals
    wire [WIDTH-1:1] C; // Carry signals

    // Compute Generate (G) and Propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    generate
        for (genvar i = 2; i <= WIDTH; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // Compute carry bits using G and P
    assign C[1] = G[1] | (P[1] & C_in);
    generate
        for (genvar i = 2; i <= WIDTH-1; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Compute sum bits
    assign S[1] = P[1] ^ C_in;
    generate
        for (genvar i = 2; i <= WIDTH; i++) begin
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // Compute carry-out
    assign C_out = G[WIDTH] | (P[WIDTH] & C[WIDTH-1]);

endmodule

// Hierarchical 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    cla #(.WIDTH(16)) u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla #(.WIDTH(16)) u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule