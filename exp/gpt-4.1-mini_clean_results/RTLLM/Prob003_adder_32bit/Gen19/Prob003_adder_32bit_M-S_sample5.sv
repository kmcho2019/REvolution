module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit = A ^ B;  // Propagate per bit
    wire [15:0] G_bit = A & B;  // Generate per bit

    wire [16:0] C;              // Carry signals
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_chain
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    assign P = &P_bit; // All propagates ANDed
    assign G = G_bit[15] | (P_bit[15] & G_bit[14]) | (P_bit[15] & P_bit[14] & G_bit[13]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & G_bit[12]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & G_bit[11]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & G_bit[10]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & G_bit[9]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & G_bit[8]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & G_bit[7]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & G_bit[6]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & G_bit[5]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & G_bit[4]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & G_bit[3]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;

    // Lower 16-bit CLA block: Cin = 0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in for upper block
    wire Cin_high = G_low | (P_low & 1'b0); // Global carry-in is zero

    // Upper 16-bit CLA block
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(),
        .G()
    );

    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule