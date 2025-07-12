module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       Pout, // block propagate
    output wire       Gout  // block generate
);
    wire [3:0] P; // propagate per bit
    wire [3:0] G; // generate per bit
    wire [4:0] C; // carries

    assign P = A ^ B;
    assign G = A & B;

    // Carry calculation with carry lookahead
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0])
                  | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];
    assign Pout = &P;        // block propagate = all bit propagates
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]); // block generate
endmodule

module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Four 4-bit CLA blocks
    wire [3:0] S0, S1, S2, S3;
    wire C1, C2, C3, C4;
    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;

    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S0),
        .Cout(C1),
        .Pout(P0),
        .Gout(G0)
    );

    // Carry into next block
    assign C2 = G0 | (P0 & C1);

    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C2),
        .S(S1),
        .Cout(C3),
        .Pout(P1),
        .Gout(G1)
    );

    assign C3 = G1 | (P1 & C3); // To be corrected below, careful with naming.

    // Wait, here we see naming clash: C3 is output from cla1, but then reused to compute carry in next block.

    // Rename to avoid confusion:
    wire C1_4bit, C2_4bit, C3_4bit, C4_4bit;
    wire Cout0, Cout1, Cout2, Cout3;

    // Re-implement carefully:

    cla_4bit cla_0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S0),
        .Cout(Cout0),
        .Pout(P0),
        .Gout(G0)
    );

    // Carry into second 4-bit block
    wire C_1 = G0 | (P0 & Cin);

    cla_4bit cla_1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C_1),
        .S(S1),
        .Cout(Cout1),
        .Pout(P1),
        .Gout(G1)
    );

    // Carry into third 4-bit block
    wire C_2 = G1 | (P1 & C_1);

    cla_4bit cla_2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C_2),
        .S(S2),
        .Cout(Cout2),
        .Pout(P2),
        .Gout(G2)
    );

    // Carry into fourth 4-bit block
    wire C_3 = G2 | (P2 & C_2);

    cla_4bit cla_3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C_3),
        .S(S3),
        .Cout(Cout3),
        .Pout(P3),
        .Gout(G3)
    );

    // Final carry out of the 16-bit block
    assign Cout = Cout3;

    // Combine sum segments
    assign S = {S3, S2, S1, S0};
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal mapping [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for (i = 0; i < 32; i = i +1) begin : map_inputs
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block carry-in zero
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block carry-in from lower block carry-out
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sums back to [32:1]
    generate
        for (i = 0; i < 16; i = i + 1) begin : map_sum_low
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : map_sum_high
            assign S[i+17] = S_high[i];
        end
    endgenerate
endmodule