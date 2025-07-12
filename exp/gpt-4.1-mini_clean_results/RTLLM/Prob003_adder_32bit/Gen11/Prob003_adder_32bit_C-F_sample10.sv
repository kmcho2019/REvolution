module cla_16bit #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire             Cin,
    output wire [WIDTH-1:0] S,
    output wire             Cout,
    output wire             P,  // Block propagate
    output wire             G   // Block generate
);
    wire [WIDTH-1:0] P_internal; // per-bit propagate
    wire [WIDTH-1:0] G_internal; // per-bit generate
    wire [WIDTH:0]   C;          // carry signals

    assign P_internal = A ^ B;
    assign G_internal = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for(i = 0; i < WIDTH; i = i + 1) begin : carry_calc
            assign C[i+1] = G_internal[i] | (P_internal[i] & C[i]);
        end
    endgenerate

    assign S = P_internal ^ C[WIDTH-1:0];
    assign Cout = C[WIDTH];

    // Block propagate: all bits propagate
    assign P = &P_internal;

    // Block generate: hierarchical carry-lookahead generate
    // G = G[WIDTH-1] + P[WIDTH-1]*G[WIDTH-2] + ... + P[WIDTH-1]*...*P[0]*Cin
    // Implement via recursive generate chain without Cin (Cin=0 in top-level usage)
    wire [WIDTH:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for(i = 1; i <= WIDTH; i = i + 1) begin : block_gen_chain
            assign Gc[i] = G_internal[i-1] | (P_internal[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[WIDTH];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based indexing wires
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for(idx = 0; idx < 32; idx = idx + 1) begin : input_mapping
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into lower and upper 16-bit chunks
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs from 16-bit CLA blocks
    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit #(.WIDTH(16)) cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Compute carry-in for upper block using block propagate and generate
    // Cin_high = G_low + P_low * 0 = G_low (since top Cin=0)
    wire Cin_high = G_low;

    // Upper 16-bit CLA block, carry-in = Cin_high
    cla_16bit #(.WIDTH(16)) cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map output sums back to 1-based indexing
    generate
        for(idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for(idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule