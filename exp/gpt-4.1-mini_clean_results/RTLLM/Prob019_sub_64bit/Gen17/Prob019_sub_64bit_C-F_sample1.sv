module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1 performed by adding ~B with cin=1
    wire [63:0] B_comp = ~B;

    // Carry chain wires between 16-bit blocks
    wire c1, c2, c3;
    
    // Instantiate four 16-bit CLA blocks
    cla_16bit cla0 (
        .A   (A[15:0]),
        .B   (B_comp[15:0]),
        .cin (1'b1),    // Adding the +1 for two's complement subtraction here
        .sum (result[15:0]),
        .cout(c1)
    );

    cla_16bit cla1 (
        .A   (A[31:16]),
        .B   (B_comp[31:16]),
        .cin (c1),
        .sum (result[31:16]),
        .cout(c2)
    );

    cla_16bit cla2 (
        .A   (A[47:32]),
        .B   (B_comp[47:32]),
        .cin (c2),
        .sum (result[47:32]),
        .cout(c3)
    );

    cla_16bit cla3 (
        .A   (A[63:48]),
        .B   (B_comp[63:48]),
        .cin (c3),
        .sum (result[63:48]),
        .cout()  // Not needed for subtraction overflow detection
    );

    // Overflow detection:
    // overflow occurs when sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit Carry Lookahead Adder (CLA)
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout
);
    wire [15:0] P; // propagate
    wire [15:0] G; // generate
    wire [16:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Carry lookahead logic using hierarchical grouping for 16 bits

    // Group size: 4 bits (4 groups)
    wire [3:0] P_group;
    wire [3:0] G_group;

    genvar i;
    generate
        // Group propagate and generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            assign P_group[i] = &P[i*4 +:4];                // AND of 4 propagate bits
            assign G_group[i] = G[i*4+3] | (P[i*4+3] & G[i*4+2]) | (P[i*4+3] & P[i*4+2] & G[i*4+1]) | (P[i*4+3] & P[i*4+2] & P[i*4+1] & G[i*4]);
        end
    endgenerate

    // Carry between groups (4 groups => 5 carries)
    wire [4:0] C_group;
    assign C_group[0] = C[0];
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & C_group[2]);
    assign C_group[4] = G_group[3] | (P_group[3] & C_group[3]);

    // Generate carry signals inside each group
    // For each 4-bit block, calculate carry bits C[i+1]
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_carry
            wire [3:0] p = P[i*4 +: 4];
            wire [3:0] g = G[i*4 +: 4];
            wire c0 = C_group[i];
            // Carry bit 1
            assign C[i*4 + 1] = g[0] | (p[0] & c0);
            // Carry bit 2
            assign C[i*4 + 2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
            // Carry bit 3
            assign C[i*4 + 3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
            // Carry bit 4
            assign C[i*4 + 4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C_group[4];

endmodule