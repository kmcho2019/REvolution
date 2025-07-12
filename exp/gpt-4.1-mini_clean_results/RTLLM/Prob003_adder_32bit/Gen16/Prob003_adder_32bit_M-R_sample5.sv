module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P, // block propagate
    output wire       G  // block generate
);
    wire [3:0] p = A ^ B; // propagate per bit
    wire [3:0] g = A & B; // generate per bit
    wire [4:0] c;         // carry signals
    
    assign c[0] = Cin;
    // Carry lookahead for 4 bits:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign S = p ^ c[3:0];
    assign Cout = c[4];
    assign P = &p; // block propagate = all bit propagates ANDed
    assign G = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]); // block generate
endmodule


module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [3:0] P_blk, G_blk; // 4 blocks of propagate and generate
    wire [3:0] C_blk;        // carry into each 4-bit block
    
    // Instantiate four 4-bit CLAs
    cla_4bit cla0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(Cin),    .S(S[3:0]),   .Cout(),      .P(P_blk[0]), .G(G_blk[0]));
    cla_4bit cla1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(C_blk[0]),.S(S[7:4]),   .Cout(),      .P(P_blk[1]), .G(G_blk[1]));
    cla_4bit cla2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(C_blk[1]),.S(S[11:8]),  .Cout(),      .P(P_blk[2]), .G(G_blk[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C_blk[2]),.S(S[15:12]), .Cout(Cout),  .P(P_blk[3]), .G(G_blk[3]));

    // Carry lookahead logic for 16-bit block across 4-bit blocks
    // C_blk[0] = carry into block 1 = G0 + P0 * Cin
    assign C_blk[0] = G_blk[0] | (P_blk[0] & Cin);
    // C_blk[1] = G1 + P1*G0 + P1*P0*Cin
    assign C_blk[1] = G_blk[1] | (P_blk[1] & G_blk[0]) | (P_blk[1] & P_blk[0] & Cin);
    // C_blk[2] = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    assign C_blk[2] = G_blk[2] 
                    | (P_blk[2] & G_blk[1]) 
                    | (P_blk[2] & P_blk[1] & G_blk[0]) 
                    | (P_blk[2] & P_blk[1] & P_blk[0] & Cin);
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;

    // Map input vectors from [32:1] to [31:0]
    generate
        for (i=0; i<32; i=i+1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Instantiate lower 16-bit CLA block with Cin=0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Instantiate upper 16-bit CLA block with Cin=C16
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
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