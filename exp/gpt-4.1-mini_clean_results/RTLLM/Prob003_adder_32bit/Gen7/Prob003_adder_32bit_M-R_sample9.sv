module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P, // Block propagate
    output wire        G  // Block generate
);

    wire [15:0] P_internal = A ^ B; // propagate per bit
    wire [15:0] G_internal = A & B; // generate per bit

    // Function to compute carry signals (C[0]..C[16])
    // Carry lookahead formula:
    // C[i+1] = G[i] + P[i]*C[i]
    // We compute all carries in parallel using generate block equations
    
    // We'll define a function that returns carry array [16:0]
    // to get Cout = C[16]

    function automatic [16:0] carry_compute;
        input [15:0] P;
        input [15:0] G;
        input        Cin_func;
        integer i;
        reg [16:0] C_temp;
        begin
            C_temp[0] = Cin_func;
            for (i = 0; i < 16; i = i +1) begin
                C_temp[i+1] = G[i] | (P[i] & C_temp[i]);
            end
            carry_compute = C_temp;
        end
    endfunction

    wire [16:0] C = carry_compute(P_internal, G_internal, Cin);

    assign S = P_internal ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: AND of all propagate bits
    assign P = &P_internal;

    // Block generate: hierarchical carry generation 
    // G = C[16]
    assign G = Cout;

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs by concatenation and slicing for conciseness
    wire [31:0] A_int = {A[32], A[31], A[30], A[29], A[28], A[27], A[26], A[25],
                         A[24], A[23], A[22], A[21], A[20], A[19], A[18], A[17],
                         A[16], A[15], A[14], A[13], A[12], A[11], A[10], A[9],
                         A[8], A[7], A[6], A[5], A[4], A[3], A[2], A[1]};
    wire [31:0] B_int = {B[32], B[31], B[30], B[29], B[28], B[27], B[26], B[25],
                         B[24], B[23], B[22], B[21], B[20], B[19], B[18], B[17],
                         B[16], B[15], B[14], B[13], B[12], B[11], B[10], B[9],
                         B[8], B[7], B[6], B[5], B[4], B[3], B[2], B[1]};

    // Alternatively, slicing with reversed indices (if your tool supports)
    // wire [31:0] A_int = {A[32:1]}; // non-synthesizable for 1-based indexing

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in to upper block computed hierarchically:
    wire Cin_high = G_low | (P_low & 1'b0); // Cin=0 in top-level adder

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Concatenate sums and map back to [32:1]
    wire [31:0] S_int = {S_high, S_low};

    // Assign outputs with explicit mapping from 0-based [31:0] to [32:1]
    assign {S[32], S[31], S[30], S[29], S[28], S[27], S[26], S[25],
            S[24], S[23], S[22], S[21], S[20], S[19], S[18], S[17],
            S[16], S[15], S[14], S[13], S[12], S[11], S[10], S[9],
            S[8],  S[7],  S[6],  S[5],  S[4],  S[3],  S[2],  S[1]} = S_int;

endmodule