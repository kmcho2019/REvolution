module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit = A ^ B;
    wire [15:0] G_bit = A & B;

    wire [16:0] C;
    assign C[0] = Cin;

    // Generate carries by simple recursive assign (no function or generate loop)
    assign C[1]  = G_bit[0]  | (P_bit[0]  & C[0]);
    assign C[2]  = G_bit[1]  | (P_bit[1]  & C[1]);
    assign C[3]  = G_bit[2]  | (P_bit[2]  & C[2]);
    assign C[4]  = G_bit[3]  | (P_bit[3]  & C[3]);
    assign C[5]  = G_bit[4]  | (P_bit[4]  & C[4]);
    assign C[6]  = G_bit[5]  | (P_bit[5]  & C[5]);
    assign C[7]  = G_bit[6]  | (P_bit[6]  & C[6]);
    assign C[8]  = G_bit[7]  | (P_bit[7]  & C[7]);
    assign C[9]  = G_bit[8]  | (P_bit[8]  & C[8]);
    assign C[10] = G_bit[9]  | (P_bit[9]  & C[9]);
    assign C[11] = G_bit[10] | (P_bit[10] & C[10]);
    assign C[12] = G_bit[11] | (P_bit[11] & C[11]);
    assign C[13] = G_bit[12] | (P_bit[12] & C[12]);
    assign C[14] = G_bit[13] | (P_bit[13] & C[13]);
    assign C[15] = G_bit[14] | (P_bit[14] & C[14]);
    assign C[16] = G_bit[15] | (P_bit[15] & C[15]);

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate is AND of all bit propagates
    assign P = &P_bit;

    // Block generate is carry out when Cin=0
    // To get G correctly, we can recompute carry with Cin=0 in parallel
    // but to simplify, use carry out with current Cin, and calculate G combinationally:

    // Simplified: G = Cout when Cin=0, so:
    wire [16:0] C_zero;
    assign C_zero[0] = 1'b0;
    assign C_zero[1]  = G_bit[0]  | (P_bit[0]  & C_zero[0]);
    assign C_zero[2]  = G_bit[1]  | (P_bit[1]  & C_zero[1]);
    assign C_zero[3]  = G_bit[2]  | (P_bit[2]  & C_zero[2]);
    assign C_zero[4]  = G_bit[3]  | (P_bit[3]  & C_zero[3]);
    assign C_zero[5]  = G_bit[4]  | (P_bit[4]  & C_zero[4]);
    assign C_zero[6]  = G_bit[5]  | (P_bit[5]  & C_zero[5]);
    assign C_zero[7]  = G_bit[6]  | (P_bit[6]  & C_zero[6]);
    assign C_zero[8]  = G_bit[7]  | (P_bit[7]  & C_zero[7]);
    assign C_zero[9]  = G_bit[8]  | (P_bit[8]  & C_zero[8]);
    assign C_zero[10] = G_bit[9]  | (P_bit[9]  & C_zero[9]);
    assign C_zero[11] = G_bit[10] | (P_bit[10] & C_zero[10]);
    assign C_zero[12] = G_bit[11] | (P_bit[11] & C_zero[11]);
    assign C_zero[13] = G_bit[12] | (P_bit[12] & C_zero[12]);
    assign C_zero[14] = G_bit[13] | (P_bit[13] & C_zero[13]);
    assign C_zero[15] = G_bit[14] | (P_bit[14] & C_zero[14]);
    assign C_zero[16] = G_bit[15] | (P_bit[15] & C_zero[15]);

    assign G = C_zero[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert inputs to zero-based indexing internally
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for(i=0; i<32; i=i+1) begin
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split inputs into two 16-bit parts
    wire [15:0] A_low = A_int[15:0];
    wire [15:0] B_low = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs and signals from lower 16-bit CLA
    wire [15:0] S_low;
    wire C16, P_low, G_low;

    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry in for upper 16-bit CLA: carry-out of lower block
    wire Cin_high = C16;

    wire [15:0] S_high;
    wire C32, P_high, G_high;

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to [32:1]
    generate
        for(i=0; i<16; i=i+1) begin
            assign S[i+1] = S_low[i];
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule