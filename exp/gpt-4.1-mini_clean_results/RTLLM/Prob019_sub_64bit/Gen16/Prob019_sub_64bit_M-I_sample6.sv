module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_comp = ~B;
    wire        carry_out;

    // Perform subtraction as A + (~B + 1)
    cla_64bit cla_sub (
        .A    (A),
        .B    (B_comp),
        .cin  (1'b1),
        .sum  (result),
        .cout (carry_out)
    );

    // Overflow detection:
    // Overflow occurs if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit hierarchical Carry Lookahead Adder (CLA)
// Implements sum = A + B + cin
// Uses 4-bit blocks with generate/propagate signals for efficient carry lookahead
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Split into 16 blocks of 4 bits each
    wire [15:0] P_block; // block propagate
    wire [15:0] G_block; // block generate
    wire [16:0] C;       // block carries: C[0] = cin, C[16] = final carry out

    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block4
            wire [3:0] p; // propagate bits for 4 bits
            wire [3:0] g; // generate bits for 4 bits
            wire [4:0] c; // carry bits inside block

            assign p = A[i*4 +: 4] ^ B[i*4 +: 4];
            assign g = A[i*4 +: 4] & B[i*4 +: 4];

            assign c[0] = C[i]; // carry in to block

            // Carry lookahead inside 4-bit block
            assign c[1] = g[0] | (p[0] & c[0]);
            assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
            assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
            assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                        | (p[3] & p[2] & p[1] & p[0] & c[0]);

            // Sum bits for block
            assign sum[i*4 +: 4] = p ^ c[3:0];

            // Block generate and propagate for carry out to next block
            assign G_block[i] = c[4];
            assign P_block[i] = &p; // all propagates must be 1 to propagate

        end
    endgenerate

    // Compute carries between blocks (hierarchical CLA for 16 blocks)
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : block_carry
            if (j == 0) begin
                assign C[1] = G_block[0] | (P_block[0] & C[0]);
            end else begin
                assign C[j+1] = G_block[j] | (P_block[j] & C[j]);
            end
        end
    endgenerate

    assign cout = C[16];

endmodule