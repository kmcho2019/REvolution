module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);

    // Per-bit propagate and generate
    wire [15:0] p = A ^ B;
    wire [15:0] g = A & B;

    // Stage 1: group of 2 bits
    wire [7:0]  gp1; // group propagate 2-bit
    wire [7:0]  gg1; // group generate 2-bit
    genvar i;

    generate
        for(i = 0; i < 8; i = i + 1) begin : stage1
            assign gp1[i] = p[i*2+1] & p[i*2];
            assign gg1[i] = g[i*2+1] | (p[i*2+1] & g[i*2]);
        end
    endgenerate

    // Stage 2: group of 4 bits
    wire [3:0] gp2;
    wire [3:0] gg2;

    generate
        for(i = 0; i < 4; i = i + 1) begin : stage2
            assign gp2[i] = gp1[2*i+1] & gp1[2*i];
            assign gg2[i] = gg1[2*i+1] | (gp1[2*i+1] & gg1[2*i]);
        end
    endgenerate

    // Stage 3: group of 8 bits
    wire [1:0] gp3;
    wire [1:0] gg3;

    generate
        for(i = 0; i < 2; i = i + 1) begin : stage3
            assign gp3[i] = gp2[2*i+1] & gp2[2*i];
            assign gg3[i] = gg2[2*i+1] | (gp2[2*i+1] & gg2[2*i]);
        end
    endgenerate

    // Stage 4: group of 16 bits
    wire gp4;
    wire gg4;

    assign gp4 = gp3[1] & gp3[0];
    assign gg4 = gg3[1] | (gp3[1] & gg3[0]);

    // Carry signals C[0]..C[16]
    wire [16:0] C;

    assign C[0] = Cin;

    // Compute carries at boundaries using prefix signals
    // C[1] = g0 + p0 * C0
    assign C[1]  = g[0] | (p[0] & C[0]);
    assign C[2]  = gg1[0] | (gp1[0] & C[0]);
    assign C[4]  = gg2[0] | (gp2[0] & C[0]);
    assign C[8]  = gg3[0] | (gp3[0] & C[0]);
    assign C[16] = gg4    | (gp4    & C[0]);

    // Intermediate carries (not boundaries) computed from known carries
    assign C[3]  = g[2]  | (p[2]  & C[2]);
    assign C[5]  = g[4]  | (p[4]  & C[4]);
    assign C[6]  = g[5]  | (p[5]  & C[5]);
    assign C[7]  = g[6]  | (p[6]  & C[6]);
    assign C[9]  = g[8]  | (p[8]  & C[8]);
    assign C[10] = g[9]  | (p[9]  & C[9]);
    assign C[11] = g[10] | (p[10] & C[10]);
    assign C[12] = g[11] | (p[11] & C[11]);
    assign C[13] = g[12] | (p[12] & C[12]);
    assign C[14] = g[13] | (p[13] & C[13]);
    assign C[15] = g[14] | (p[14] & C[14]);

    // Compute the carries for bits not explicitly assigned above by linear carry:
    // bits: 1 (done),3,5-7,9-15 covered; for bits 1,3,5..15 done
    // missing:  (bit 1 done), bits 2,4,8,16 are boundaries, others are assigned
    // bit 1 carry already assigned, bits 2,4,8,16 assigned
    // bits 1..15 all assigned here

    // For bits 1..15 carry signals are computed.

    // sum bit calculation
    // S[i] = p[i] xor C[i]
    genvar j;
    generate
        for(j=0; j<16; j=j+1) begin : sum_gen
            assign S[j] = p[j] ^ C[j];
        end
    endgenerate

    assign Cout = C[16];
    assign P = gp4;
    assign G = gg4;

endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Map to zero-based indexing internally
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar k;
    generate
        for(k=0; k<32; k=k+1) begin : map_inputs
            assign A_int[k] = A[k+1];
            assign B_int[k] = B[k+1];
        end
    endgenerate

    // Split inputs into low and high 16-bit
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Lower 16-bit CLA with Cin=0
    cla_16bit cla0 (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry in to upper block from lower block
    wire Cin_high = G_low; // since global Cin=0

    // Upper 16-bit CLA
    cla_16bit cla1 (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to 1-based indexing
    generate
        for(k=0; k<16; k=k+1) begin : map_sum_low
            assign S[k+1] = S_low[k];
        end
        for(k=0; k<16; k=k+1) begin : map_sum_high
            assign S[k+17] = S_high[k];
        end
    endgenerate

endmodule