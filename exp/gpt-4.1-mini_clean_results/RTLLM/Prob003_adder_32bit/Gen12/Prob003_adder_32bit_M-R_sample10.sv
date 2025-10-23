module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // block propagate
    output wire        G   // block generate
);
    wire [15:0] P_bit; // per-bit propagate
    wire [15:0] G_bit; // per-bit generate

    assign P_bit = A ^ B;
    assign G_bit = A & B;

    // Level 1 group signals: groups of 2 bits
    wire [7:0] P_1;
    wire [7:0] G_1;
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : lvl1
            assign P_1[i] = P_bit[2*i+1] & P_bit[2*i];
            assign G_1[i] = G_bit[2*i+1] | (P_bit[2*i+1] & G_bit[2*i]);
        end
    endgenerate

    // Level 2 group signals: groups of 4 bits
    wire [3:0] P_2;
    wire [3:0] G_2;
    generate
        for(i=0; i<4; i=i+1) begin : lvl2
            assign P_2[i] = P_1[2*i+1] & P_1[2*i];
            assign G_2[i] = G_1[2*i+1] | (P_1[2*i+1] & G_1[2*i]);
        end
    endgenerate

    // Level 3 group signals: groups of 8 bits
    wire [1:0] P_3;
    wire [1:0] G_3;
    generate
        for(i=0; i<2; i=i+1) begin : lvl3
            assign P_3[i] = P_2[2*i+1] & P_2[2*i];
            assign G_3[i] = G_2[2*i+1] | (P_2[2*i+1] & G_2[2*i]);
        end
    endgenerate

    // Level 4 group signal: 16 bits
    wire P_4 = P_3[1] & P_3[0];
    wire G_4 = G_3[1] | (P_3[1] & G_3[0]);

    // Carry signals
    wire [16:0] C;

    assign C[0] = Cin;

    // Compute carries at group boundaries
    // Using precomputed group propagates and generates:

    // C[1] to C[16] calculated as below:

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

    // Compute sum bits
    assign S = P_bit ^ C[15:0];

    assign Cout = C[16];

    // Block propagate and generate signals
    assign P = P_4;
    assign G = G_4;
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert 1-based indexing inputs to 0-based internal wires
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar j;
    generate
        for(j=0; j<32; j=j+1) begin : map_inputs
            assign A_int[j] = A[j+1];
            assign B_int[j] = B[j+1];
        end
    endgenerate

    // Instantiate lower 16-bit CLA
    wire [15:0] S_low;
    wire        Cout_low;
    wire        P_low, G_low;

    cla_16bit cla_low (
        .A    (A_int[15:0]),
        .B    (B_int[15:0]),
        .Cin  (1'b0),
        .S    (S_low),
        .Cout (Cout_low),
        .P    (P_low),
        .G    (G_low)
    );

    // Calculate carry-in for upper 16 bits using CLA block formula: C_in_high = G_low + P_low * Cin_low (Cin_low=0)
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA
    wire [15:0] S_high;
    wire        Cout_high;
    wire        P_high, G_high;

    cla_16bit cla_high (
        .A    (A_int[31:16]),
        .B    (B_int[31:16]),
        .Cin  (Cin_high),
        .S    (S_high),
        .Cout (Cout_high),
        .P    (P_high),
        .G    (G_high)
    );

    assign C32 = Cout_high;

    // Map 0-based outputs back to 1-based output ports
    generate
        for(j=0; j<16; j=j+1) begin : map_sum_low
            assign S[j+1] = S_low[j];
        end
        for(j=0; j<16; j=j+1) begin : map_sum_high
            assign S[j+17] = S_high[j];
        end
    endgenerate

endmodule