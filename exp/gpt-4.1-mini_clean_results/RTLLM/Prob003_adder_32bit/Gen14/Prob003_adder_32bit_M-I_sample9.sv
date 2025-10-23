module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,   // group propagate
    output wire       G    // group generate
);
    wire [3:0] P_bit = A ^ B;
    wire [3:0] G_bit = A & B;

    // Carry signals
    wire c1, c2, c3;

    // Generate carries for bits 1..3
    assign c1 = G_bit[0] | (P_bit[0] & Cin);
    assign c2 = G_bit[1] | (P_bit[1] & c1);
    assign c3 = G_bit[2] | (P_bit[2] & c2);
    assign Cout = G_bit[3] | (P_bit[3] & c3);

    assign S = P_bit ^ {c3, c2, c1, Cin};

    // Group propagate: all bits propagate
    assign P = &P_bit;

    // Group generate: generate occurs if
    // G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G = G_bit[3] |
               (P_bit[3] & G_bit[2]) |
               (P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
endmodule

module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    // Instantiate four 4-bit CLAs
    wire [3:0] S0, S1, S2, S3;
    wire       C1, C2, C3;
    wire       P0, P1, P2, P3;
    wire       G0, G1, G2, G3;

    cla_4bit cla0 (.A(A[3:0]),    .B(B[3:0]),    .Cin(Cin), .S(S0), .Cout(C1), .P(P0), .G(G0));
    cla_4bit cla1 (.A(A[7:4]),    .B(B[7:4]),    .Cin(C1),  .S(S1), .Cout(C2), .P(P1), .G(G1));
    cla_4bit cla2 (.A(A[11:8]),   .B(B[11:8]),   .Cin(C2),  .S(S2), .Cout(C3), .P(P2), .G(G2));
    cla_4bit cla3 (.A(A[15:12]),  .B(B[15:12]),  .Cin(C3),  .S(S3), .Cout(Cout), .P(P3), .G(G3));

    // Compute intermediate carry-ins for groups using carry-lookahead logic
    // C1, C2, C3 already computed by chaining smaller CLAs.
    // To improve speed, we compute C1-C3 using generate and propagate signals instead of chaining:
    // But here, since carries are outputs from each 4-bit CLA, they reflect the final carry-ins.

    // Block propagate and generate for 16 bits
    assign P = P0 & P1 & P2 & P3;
    // Block generate for 16 bits:
    // G = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0)
    assign G = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);

    // Concatenate sums
    assign S = {S3, S2, S1, S0};
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert 1-based [32:1] to zero-based [31:0]
    wire [31:0] A_int, B_int;
    genvar i;
    generate
        for (i = 0; i < 32; i = i +1) begin : input_mapping
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split into two 16-bit halves
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Lower 16-bit CLA: carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Compute carry-in for upper block
    // Cin_high = G_low | (P_low & 0) = G_low
    wire Cin_high = G_low;

    // Upper 16-bit CLA
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum outputs back from zero-based [31:0] to one-based [32:1]
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate
endmodule