module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit, G_bit;
    wire [16:0] carry;

    assign P_bit = A ^ B;
    assign G_bit = A & B;

    assign carry[0] = Cin;
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : carry_gen
            assign carry[i+1] = G_bit[i] | (P_bit[i] & carry[i]);
        end
    endgenerate

    assign S = P_bit ^ carry[15:0];
    assign Cout = carry[16];
    assign P = &P_bit;  // block propagate
    assign G = carry[16] & ~Cin;  // block generate = carry_out with Cin=0

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int, B_int;
    genvar i;

    // Remap input bits [32:1] to [31:0]
    generate
        for (i=0; i<32; i=i+1) begin : input_reindex
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
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA with Cin=0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Upper 16-bit CLA with carry-in = G_low (since Cin=0)
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(G_low),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map outputs back from zero-based [31:0] to [32:1]
    generate
        for (i=0; i<16; i=i+1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i=0; i<16; i=i+1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule