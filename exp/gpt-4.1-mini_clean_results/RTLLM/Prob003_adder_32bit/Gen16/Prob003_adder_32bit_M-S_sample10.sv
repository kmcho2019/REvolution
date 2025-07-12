module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] p = A ^ B;  // propagate
    wire [15:0] g = A & B;  // generate

    wire [16:0] c;
    assign c[0] = Cin;

    // Carry calculation using ripple for loop (fast enough for 16 bits)
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : carry_calc
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign S = p ^ c[15:0];
    assign Cout = c[16];
    assign P = &p;
    assign G = g[15] | (p[15] & g[14]) | 
               (p[15] & p[14] & g[13]) | 
               (p[15] & p[14] & p[13] & g[12]) | 
               (p[15] & p[14] & p[13] & p[12] & g[11]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & g[10]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & g[9])  |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & g[8]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & g[7]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & g[6]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & g[5]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & p[5] & g[4]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & p[5] & p[4] & g[3]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & p[8] & p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);

endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert inputs to zero-based index vectors for easy slicing
    wire [31:0] A_int = {A[32], A[31], A[30], A[29], A[28], A[27], A[26], A[25],
                         A[24], A[23], A[22], A[21], A[20], A[19], A[18], A[17],
                         A[16], A[15], A[14], A[13], A[12], A[11], A[10], A[9],
                         A[8],  A[7],  A[6],  A[5],  A[4],  A[3],  A[2],  A[1]};
    wire [31:0] B_int = {B[32], B[31], B[30], B[29], B[28], B[27], B[26], B[25],
                         B[24], B[23], B[22], B[21], B[20], B[19], B[18], B[17],
                         B[16], B[15], B[14], B[13], B[12], B[11], B[10], B[9],
                         B[8],  B[7],  B[6],  B[5],  B[4],  B[3],  B[2],  B[1]};

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    cla_16bit cla_lo (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    wire Cin_high = G_low | (P_low & 1'b0); // Cin_high = G_low, as lower carry-in is 0

    cla_16bit cla_hi (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Concatenate outputs back with [32:1] indexing
    assign S = {S_high[15], S_high[14], S_high[13], S_high[12], S_high[11], S_high[10], S_high[9], S_high[8],
                S_high[7],  S_high[6],  S_high[5],  S_high[4],  S_high[3],  S_high[2],  S_high[1], S_high[0],
                S_low[15],  S_low[14],  S_low[13],  S_low[12],  S_low[11],  S_low[10],  S_low[9],  S_low[8],
                S_low[7],   S_low[6],   S_low[5],   S_low[4],   S_low[3],   S_low[2],   S_low[1],  S_low[0]};

endmodule