module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,  // group propagate
    output wire       G   // group generate
);
    wire [3:0] p; // propagate per bit
    wire [3:0] g; // generate per bit
    wire [4:0] c; // carry signals

    assign p = A ^ B;
    assign g = A & B;
    assign c[0] = Cin;

    // Generate carry signals inside the 4-bit block
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign S = p ^ c[3:0];
    assign Cout = c[4];

    // Group propagate: all bits propagate
    assign P = &p; // AND of all p bits
    // Group generate: any generate or propagated generate
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule


module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Divide 16 bits into four 4-bit CLA blocks
    wire [3:0] P;  // group propagate signals of 4-bit blocks
    wire [3:0] G;  // group generate signals of 4-bit blocks
    wire [4:0] C;  // carries for block-level (C[0] = Cin)

    assign C[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla_blocks [3:0] (
        .A(A[ 3: 0]),
        .B(B[ 3: 0]),
        .Cin(C[0]),
        .S(S[ 3: 0]),
        .Cout(),  // unused here
        .P(P[0]),
        .G(G[0])
    );
    cla_4bit cla_blocks1 (
        .A(A[ 7: 4]),
        .B(B[ 7: 4]),
        .Cin(C[1]),
        .S(S[ 7: 4]),
        .Cout(),
        .P(P[1]),
        .G(G[1])
    );
    cla_4bit cla_blocks2 (
        .A(A[11: 8]),
        .B(B[11: 8]),
        .Cin(C[2]),
        .S(S[11: 8]),
        .Cout(),
        .P(P[2]),
        .G(G[2])
    );
    cla_4bit cla_blocks3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[3]),
        .S(S[15:12]),
        .Cout(),
        .P(P[3]),
        .G(G[3])
    );

    // Carry-lookahead logic to compute carries for the 4-bit blocks
    // Using CLA carry equations for block carries:
    // C[1] = G[0] + P[0]*C[0]
    // C[2] = G[1] + P[1]*C[1]
    // C[3] = G[2] + P[2]*C[2]
    // C[4] = G[3] + P[3]*C[3]
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    assign Cout = C[4];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based 31:0 signals for convenience
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    wire [15:0] S_low;
    wire [15:0] S_high;
    wire C16;

    // Instantiate lower 16-bit CLA block with Cin=0
    cla_16bit cla_low (
        .A(A_int[15:0]),
        .B(B_int[15:0]),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Instantiate upper 16-bit CLA block with Cin = carry out of lower block
    cla_16bit cla_high (
        .A(A_int[31:16]),
        .B(B_int[31:16]),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum outputs back to [32:1]
    generate
        for (i=0; i<16; i=i+1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i=0; i<16; i=i+1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate
endmodule