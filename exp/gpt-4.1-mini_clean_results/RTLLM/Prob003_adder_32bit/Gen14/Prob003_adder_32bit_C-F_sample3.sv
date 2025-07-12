module cla_16bit (
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [16:1] P_bit;  // propagate signals per bit
    wire [16:1] G_bit;  // generate signals per bit
    wire [16:0] C;      // carry signals per bit including initial Cin

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_loop
            assign C[i] = G_bit[i] | (P_bit[i] & C[i-1]);
        end
    endgenerate

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate is AND of all propagate bits
    assign P = &P_bit;

    // Block generate is last carry-out with Cin=0, which equals 
    // G_block = G[16] computed with Cin=0
    // Since C[i] = G_bit[i] | (P_bit[i] & C[i-1]), with C[0]=0:
    // Recompute block generate:
    wire [16:0] C_zero_in;
    assign C_zero_in[0] = 1'b0;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : block_gen_loop
            assign C_zero_in[i] = G_bit[i] | (P_bit[i] & C_zero_in[i-1]);
        end
    endgenerate
    assign G = C_zero_in[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P_low),
        .G   (G_low)
    );

    // Carry in to upper block = G_low | (P_low & Cin_low), but Cin_low=0
    wire Cin_high = G_low;

    // Upper 16-bit CLA
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (Cin_high),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P_high),
        .G   (G_high)
    );

endmodule