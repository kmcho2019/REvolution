module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_inv = ~B;

    // Instantiate 64-bit carry-select adder for A + B_inv + 1
    // The carry_in for subtraction is 1 (two's complement addition)
    wire [63:0] sum;
    wire        cout;

    csla_64bit u_csla_64bit (
        .A   (A),
        .B   (B_inv),
        .cin (1'b1),
        .sum (sum),
        .cout(cout)
    );

    assign result = sum;

    // Overflow detection for subtraction:
    // Overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 64-bit Carry-Select Adder with 8-bit blocks (8 blocks total)
module csla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Number of blocks
    localparam BLOCKS = 8;
    localparam BLOCK_SIZE = 8;

    wire [BLOCKS:0] carry;   // carry signals between blocks
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < BLOCKS; i = i + 1) begin : block
            csla_8bit block_adder (
                .A    (A[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .B    (B[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cin  (carry[i]),
                .sum  (sum[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cout (carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[BLOCKS];

endmodule

// 8-bit Carry-Select Adder block
module csla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        cin,
    output wire [7:0]  sum,
    output wire        cout
);
    // Precompute sum and carry assuming carry-in = 0
    wire [7:0] sum0;
    wire       c0;

    // Precompute sum and carry assuming carry-in = 1
    wire [7:0] sum1;
    wire       c1;

    ripple_carry_adder_8bit rca0 (
        .A   (A),
        .B   (B),
        .cin (1'b0),
        .sum (sum0),
        .cout(c0)
    );

    ripple_carry_adder_8bit rca1 (
        .A   (A),
        .B   (B),
        .cin (1'b1),
        .sum (sum1),
        .cout(c1)
    );

    // Select sum and carry based on actual carry-in
    assign sum  = cin ? sum1 : sum0;
    assign cout = cin ? c1   : c0;

endmodule

// 8-bit Ripple Carry Adder for internal use in CSLA blocks
module ripple_carry_adder_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] c;

    // Full adders chain
    assign {c[0], sum[0]} = A[0] + B[0] + cin;
    assign {c[1], sum[1]} = A[1] + B[1] + c[0];
    assign {c[2], sum[2]} = A[2] + B[2] + c[1];
    assign {c[3], sum[3]} = A[3] + B[3] + c[2];
    assign {c[4], sum[4]} = A[4] + B[4] + c[3];
    assign {c[5], sum[5]} = A[5] + B[5] + c[4];
    assign {c[6], sum[6]} = A[6] + B[6] + c[5];
    assign {c[7], sum[7]} = A[7] + B[7] + c[6];

    assign cout = c[7];
endmodule