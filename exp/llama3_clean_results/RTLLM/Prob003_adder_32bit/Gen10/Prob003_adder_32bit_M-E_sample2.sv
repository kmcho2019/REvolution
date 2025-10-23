// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] G, P;
    wire [7:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= 8; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values
    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[8] + (P[8] & C[7]);

    // Calculate S values
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// Prefix Adder for Carry Values
module prefix_adder(
    input [3:1] C_in,
    output [3:1] C_out
);

    wire [2:1] C1, C2;

    assign C1[1] = C_in[1];
    assign C1[2] = C_in[2] + (C_in[1] & C_in[2]);
    assign C2[1] = C_in[3] + (C_in[2] & C_in[3]);
    assign C2[2] = C_in[1] & C_in[2] & C_in[3];

    assign C_out[1] = C_in[1];
    assign C_out[2] = C1[2];
    assign C_out[3] = C2[1];

endmodule

// 32-bit Hybrid Carry-Lookahead Prefix Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [3:1] C_seg;
    wire [3:1] C_out_seg;

    // Divide the 32-bit addition into four 8-bit segments
    cla_8bit seg1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C_seg[1])
    );

    cla_8bit seg2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C_seg[1]),
        .S(S[16:9]),
        .C_out(C_seg[2])
    );

    cla_8bit seg3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C_seg[2]),
        .S(S[24:17]),
        .C_out(C_seg[3])
    );

    cla_8bit seg4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C_seg[3]),
        .S(S[32:25]),
        .C_out(C32)
    );

    // Use a prefix adder to combine the carry-out values from each segment
    prefix_adder prefix_add(
        .C_in(C_seg),
        .C_out(C_out_seg)
    );

endmodule