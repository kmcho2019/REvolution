module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for power savings
    wire [63:0] B_comp = ~B;

    // Wires for intermediate signals
    wire [15:0] sum_seg [3:0];
    wire [3:0]  carry_seg;      // carry signals between 16-bit blocks
    wire        cin = 1'b1;     // initial carry-in for two's complement (+1)

    // Generate 4 segments of 16 bits each
    // Block carries: carry_seg[0] through carry_seg[3]
    // carry_seg[0] is carry-in to first 16-bit block = cin
    // carry_seg[4] (not declared) would be final carry out, unused here
    assign carry_seg[0] = cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_sub_16bit
            cla_16bit_sub subtractor_16bit (
                .A      (A[i*16 +: 16]),
                .B_comp (B_comp[i*16 +: 16]),
                .cin    (carry_seg[i]),
                .sum    (sum_seg[i]),
                .cout   (carry_seg[i+1])
            );
        end
    endgenerate

    assign result = {sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]};

    // Overflow detection for subtraction: overflow if
    // A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 16-bit CLA subtractor for sum = A + B_comp + cin
module cla_16bit_sub (
    input  wire [15:0] A,
    input  wire [15:0] B_comp,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout
);
    wire [15:0] P;  // propagate
    wire [15:0] G;  // generate
    wire [16:0] C;  // carry signals

    assign P = A ^ B_comp;
    assign G = A & B_comp;
    assign C[0] = cin;

    // Hierarchical 4-bit CLA within 16-bit block to speed carry generation
    wire [3:0] P_group;
    wire [3:0] G_group;
    wire [4:0] C_group;

    genvar i;
    generate
        // Generate group propagate and generate signals for each 4-bit chunk
        for (i=0; i<4; i=i+1) begin : gen_pg_group
            assign P_group[i] = &P[i*4 +: 4];                      // AND of 4 propagates
            assign G_group[i] = G[i*4 +3] | (P[i*4 +3] & G[i*4 +2]) |
                               (P[i*4 +3] & P[i*4 +2] & G[i*4 +1]) |
                               (P[i*4 +3] & P[i*4 +2] & P[i*4 +1] & G[i*4 +0]);
        end
    endgenerate

    // Carry lookahead for group carries
    assign C_group[0] = C[0];
    generate
        for (i=0; i<4; i=i+1) begin : gen_cgroup
            assign C_group[i+1] = G_group[i] | (P_group[i] & C_group[i]);
        end
    endgenerate

    // Calculate individual bit carries from group carries and P,G signals
    generate
        for (i=0; i<16; i=i+1) begin : gen_carry_bits
            if ((i % 4) == 0) begin
                // The carry-in of the first bit in each group is the group's carry-in
                assign C[i+1] = C_group[i/4];
            end else begin
                // Calculate carry within group bits
                assign C[i+1] = G[i-1] | (P[i-1] & C[i]);
            end
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C_group[4]; // carry out from the 16-bit block

endmodule