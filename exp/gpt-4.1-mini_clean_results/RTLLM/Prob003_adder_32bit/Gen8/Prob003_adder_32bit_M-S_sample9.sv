module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,
    output wire        G_block
);
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Carries: C[0] = Cin
    wire [16:0] C;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: AND of all propagates
    assign P_block = &P;

    // Block generate: iterative calculation without intermediate array
    reg G_blk;
    integer j;
    always @(*) begin
        G_blk = G[0];
        for (j = 1; j < 16; j = j + 1) begin
            G_blk = G[j] | (P[j] & G_blk);
        end
    end
    assign G_block = G_blk;
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P0, G0, P1, G1;

    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    wire Cin_high = G0 | (P0 & 1'b0); // Cin=0

    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin
            assign S[idx+1] = S_low[idx];
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule