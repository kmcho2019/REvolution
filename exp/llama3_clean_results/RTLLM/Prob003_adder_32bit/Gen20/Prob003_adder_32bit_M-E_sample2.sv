// Segmented Carry-Lookahead Adder module
module scla #(
    parameter SEGMENT_SIZE = 8
)(
    input [SEGMENT_SIZE:1] A,
    input [SEGMENT_SIZE:1] B,
    input C_in,
    output [SEGMENT_SIZE:1] S,
    output C_out
);
    wire [SEGMENT_SIZE:1] G, P; // Generate and Propagate signals
    wire [SEGMENT_SIZE-1:1] C; // Carry signals

    // Compute Generate (G) and Propagate (P) signals directly
    for (genvar i = 1; i <= SEGMENT_SIZE; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Compute carry bits using G and P directly
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= SEGMENT_SIZE-1; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end

    // Compute sum bits directly
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= SEGMENT_SIZE; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

    // Compute carry-out directly
    assign C_out = G[SEGMENT_SIZE] | (P[SEGMENT_SIZE] & C[SEGMENT_SIZE-1]);

endmodule

// Hierarchical 32-bit Segmented Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C8, C16, C24;

    scla #(.SEGMENT_SIZE(8)) u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C8)
    );

    scla #(.SEGMENT_SIZE(8)) u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C16)
    );

    scla #(.SEGMENT_SIZE(8)) u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C16),
        .S(S[24:17]),
        .C_out(C24)
    );

    scla #(.SEGMENT_SIZE(8)) u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C24),
        .S(S[32:25]),
        .C_out(C32)
    );

endmodule