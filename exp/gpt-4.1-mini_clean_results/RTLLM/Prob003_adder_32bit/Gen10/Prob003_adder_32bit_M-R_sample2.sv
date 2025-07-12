module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,  // Group propagate
    output wire       G   // Group generate
);
    // Per-bit propagate and generate
    wire [3:0] p = A ^ B;
    wire [3:0] g = A & B;

    // Carry signals
    wire c1 = g[0] | (p[0] & Cin);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);
    wire c4 = g[3] | (p[3] & c3);

    assign S = p ^ {c3, c2, c1, Cin};
    assign Cout = c4;

    // Group propagate: all bits propagate
    assign P = &p;

    // Group generate: G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
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
    // Break 16 bits into 4 groups of 4 bits
    wire [3:0] p_group;
    wire [3:0] g_group;
    wire [4:0] c; // carries between groups

    assign c[0] = Cin;

    // Instantiate 4-bit CLA blocks for each group
    cla_4bit cla0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(c[0]), .S(S[3:0]),   .Cout(),      .P(p_group[0]), .G(g_group[0]));
    cla_4bit cla1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(c[1]), .S(S[7:4]),   .Cout(),      .P(p_group[1]), .G(g_group[1]));
    cla_4bit cla2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(c[2]), .S(S[11:8]),  .Cout(),      .P(p_group[2]), .G(g_group[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(c[3]), .S(S[15:12]), .Cout(Cout),  .P(p_group[3]), .G(g_group[3]));

    // Compute carries between groups
    assign c[1] = g_group[0] | (p_group[0] & c[0]);
    assign c[2] = g_group[1] | (p_group[1] & c[1]);
    assign c[3] = g_group[2] | (p_group[2] & c[2]);
    assign c[4] = g_group[3] | (p_group[3] & c[3]); // Should be equal to Cout

    // Block propagate is AND of group propagates
    assign P = &p_group;

    // Block generate via hierarchical formula
    assign G = g_group[3]
             | (p_group[3] & g_group[2])
             | (p_group[3] & p_group[2] & g_group[1])
             | (p_group[3] & p_group[2] & p_group[1] & g_group[0]);
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map input vectors [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA with carry in 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Calculate carry-in for upper block using block propagate and generate with Cin=0
    wire Cin_high = G_low | (P_low & 1'b0); // Simplified to G_low, but cleaner form kept

    // Upper 16-bit CLA block with calculated carry-in
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map outputs back to [32:1]
    generate
        for(i = 0; i < 16; i = i + 1) begin : output_map_low
            assign S[i+1] = S_low[i];
        end
        for(i = 0; i < 16; i = i + 1) begin : output_map_high
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule