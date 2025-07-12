module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Break inputs into 4 segments of 16 bits each
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];
    wire        borrow [4:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    assign borrow[0] = 1'b1;  // initial carry-in = 1 for two's complement subtraction

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sub_16bit_blocks
            sub_16bit_cla u_sub16 (
                .A         (A_seg[i]),
                .B         (B_seg[i]),
                .cin       (borrow[i]),
                .result    (R_seg[i]),
                .cout      (borrow[i+1])
            );
        end
    endgenerate

    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection for subtraction:
    // Overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit subtractor composed of two 8-bit CLA subtractors chained internally with carry/borrow
module sub_16bit_cla (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,     // carry-in (borrow-in) for 16-bit subtractor
    output wire [15:0] result,
    output wire        cout     // carry-out (borrow-out) from 16-bit subtractor
);

    wire carry_mid;  // internal carry between lower 8-bit and upper 8-bit CLA blocks

    // Lower 8 bits CLA subtractor
    cla_8bit_sub cla_low (
        .A    (A[7:0]),
        .B    (B[7:0]),
        .cin  (cin),
        .sum  (result[7:0]),
        .cout (carry_mid)
    );

    // Upper 8 bits CLA subtractor
    cla_8bit_sub cla_high (
        .A    (A[15:8]),
        .B    (B[15:8]),
        .cin  (carry_mid),
        .sum  (result[15:8]),
        .cout (cout)
    );

endmodule


// 8-bit CLA subtractor implementing sum = A + (~B) + cin
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,    // carry-in for subtractor (borrow-in)
    output wire [7:0] sum,
    output wire       cout    // carry-out (borrow-out)
);
    wire [7:0] B_neg = ~B; // complement B bits

    wire [7:0] P;   // propagate signals
    wire [7:0] G;   // generate signals
    wire [8:0] C;   // carry signals, C[0] = cin

    assign P = A ^ B_neg; 
    assign G = A & B_neg;
    assign C[0] = cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_logic
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[7:0];
    assign cout = C[8];

endmodule