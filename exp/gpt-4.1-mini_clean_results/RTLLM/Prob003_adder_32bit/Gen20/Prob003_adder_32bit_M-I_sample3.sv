// 16-bit Carry Lookahead Adder with Parallel Prefix (Kogge-Stone-like) Structure
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit, G_bit;   // per bit propagate and generate
    wire [15:0] Gp;             // prefix generate signals after prefix tree
    wire [15:0] Pp;             // prefix propagate signals after prefix tree
    wire [16:0] C;              // carry signals C[0]=Cin .. C[16] = carry out

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    // Define a black cell: combine two pairs of (G,P)
    // black_cell: Inputs: (G_kj,P_kj), (G_ji,P_ji)
    // Outputs: G_ki = G_kj + P_kj * G_ji, P_ki = P_kj * P_ji
    function automatic [1:0] black_cell;
        input G_kj, P_kj, G_ji, P_ji;
        reg G_ki;
        reg P_ki;
        begin
            G_ki = G_kj | (P_kj & G_ji);
            P_ki = P_kj & P_ji;
            black_cell = {G_ki, P_ki};
        end
    endfunction

    // Initialize prefix propagate/generate with per-bit signals
    // Level 0
    assign Gp = G_bit;
    assign Pp = P_bit;

    // Prefix computation levels:
    // We implement 4 levels of prefix combining for 16 bits
    // We'll store intermediate prefix results in wires at each level

    // Level 1: Combine pairs (distance 1)
    wire [15:0] G1, P1;
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            if (i == 0) begin
                assign G1[i] = Gp[i];
                assign P1[i] = Pp[i];
            end else begin
                // Combine with element i-1
                wire [1:0] bc = black_cell(Gp[i], Pp[i], Gp[i-1], Pp[i-1]);
                assign G1[i] = bc[1] ? Gp[i] : bc[0]; // corrected below
                assign G1[i] = bc[0];
                assign P1[i] = bc[1];
            end
        end
    endgenerate

    // After reconsideration: black_cell returns {G_ki,P_ki} = {bc[1:0]} (G is MSB)
    // So bc[1] = G_ki, bc[0] = P_ki
    // Correction:
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_corrected
            if (i == 0) begin
                assign G1[i] = Gp[i];
                assign P1[i] = Pp[i];
            end else begin
                wire [1:0] bc = black_cell(Gp[i], Pp[i], Gp[i-1], Pp[i-1]);
                assign G1[i] = bc[1];
                assign P1[i] = bc[0];
            end
        end
    endgenerate

    // Level 2: Combine pairs (distance 2)
    wire [15:0] G2, P2;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level2
            if (i < 2) begin
                assign G2[i] = G1[i];
                assign P2[i] = P1[i];
            end else begin
                wire [1:0] bc = black_cell(G1[i], P1[i], G1[i-2], P1[i-2]);
                assign G2[i] = bc[1];
                assign P2[i] = bc[0];
            end
        end
    endgenerate

    // Level 3: Combine pairs (distance 4)
    wire [15:0] G3, P3;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level3
            if (i < 4) begin
                assign G3[i] = G2[i];
                assign P3[i] = P2[i];
            end else begin
                wire [1:0] bc = black_cell(G2[i], P2[i], G2[i-4], P2[i-4]);
                assign G3[i] = bc[1];
                assign P3[i] = bc[0];
            end
        end
    endgenerate

    // Level 4: Combine pairs (distance 8)
    wire [15:0] G4, P4;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level4
            if (i < 8) begin
                assign G4[i] = G3[i];
                assign P4[i] = P3[i];
            end else begin
                wire [1:0] bc = black_cell(G3[i], P3[i], G3[i-8], P3[i-8]);
                assign G4[i] = bc[1];
                assign P4[i] = bc[0];
            end
        end
    endgenerate

    // Now generate carries C[1..16] using prefix generate and propagate with Cin
    // Carry in for bit 0 is Cin (C[0])
    // Carry for bit i+1 is G_i + P_i * C[0], where G_i and P_i come from prefix tree at G4[i],P4[i]
    // So C[i+1] = G4[i] | (P4[i] & C[0]) = G4[i] | (P4[i] & Cin)

    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_calc
            assign C[i+1] = G4[i] | (P4[i] & C[0]);
        end
    endgenerate

    // Sum bits: S[i] = P_bit[i] ^ C[i]
    assign S = P_bit ^ C[15:0];

    // Carry-out (Cout) is C[16]
    assign Cout = C[16];

    // Block propagate: AND of all propagate bits
    assign P = &P_bit;

    // Block generate is the overall generate signal G4[15] combined with propagate and Cin:
    // G = G4[15] | (P4[15] & Cin)
    assign G = G4[15] | (P4[15] & Cin);

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors [31:0] mapped from [32:1]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into low and high 16-bit halves
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Wires for outputs from CLA blocks
    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Instantiate lower 16-bit CLA block (carry-in = 0)
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in for upper 16-bit block is generated from lower block signals
    // Carry_in_upper = G_low + P_low*0 = G_low
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum outputs back to [32:1] indexing cleanly
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule