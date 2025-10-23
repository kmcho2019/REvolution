module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_comp = ~B;  // bitwise inversion of B for two's complement

    // Wires for sum and carry out of each 16-bit block for carry_in=0 and carry_in=1
    wire [15:0] sum0_0, sum0_1;
    wire        cout0_0, cout0_1;

    wire [15:0] sum1_0, sum1_1;
    wire        cout1_0, cout1_1;

    wire [15:0] sum2_0, sum2_1;
    wire        cout2_0, cout2_1;

    wire [15:0] sum3_0, sum3_1;
    wire        cout3_0, cout3_1;

    // Actual carry signals between blocks (select lines)
    wire c1, c2, c3;

    // --- Block 0: bits [15:0] ---
    // Subtraction: A + ~B + 1 means carry_in=1 for the least significant block
    cla_16bit cla0_1 (
        .A(A[15:0]),
        .B(B_comp[15:0]),
        .cin(1'b1),
        .sum(sum0_1),
        .cout(cout0_1)
    );

    // Also compute with carry_in=0 (not used for LSB but precomputed for consistency)
    cla_16bit cla0_0 (
        .A(A[15:0]),
        .B(B_comp[15:0]),
        .cin(1'b0),
        .sum(sum0_0),
        .cout(cout0_0)
    );

    // Select sum0 and carry out for block 0: carry_in fixed to 1
    wire [15:0] sum0 = sum0_1;
    wire        cout0 = cout0_1;

    // --- Block 1: bits [31:16] ---
    // Precompute sum and carry assuming carry_in=0 and carry_in=1
    cla_16bit cla1_0 (
        .A(A[31:16]),
        .B(B_comp[31:16]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(cout1_0)
    );
    cla_16bit cla1_1 (
        .A(A[31:16]),
        .B(B_comp[31:16]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(cout1_1)
    );

    // Select correct sum and carry out based on cout0
    assign c1 = cout0;
    wire [15:0] sum1 = c1 ? sum1_1 : sum1_0;
    wire        cout1 = c1 ? cout1_1 : cout1_0;

    // --- Block 2: bits [47:32] ---
    cla_16bit cla2_0 (
        .A(A[47:32]),
        .B(B_comp[47:32]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(cout2_0)
    );
    cla_16bit cla2_1 (
        .A(A[47:32]),
        .B(B_comp[47:32]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(cout2_1)
    );

    assign c2 = cout1;
    wire [15:0] sum2 = c2 ? sum2_1 : sum2_0;
    wire        cout2 = c2 ? cout2_1 : cout2_0;

    // --- Block 3: bits [63:48] ---
    cla_16bit cla3_0 (
        .A(A[63:48]),
        .B(B_comp[63:48]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(cout3_0)
    );
    cla_16bit cla3_1 (
        .A(A[63:48]),
        .B(B_comp[63:48]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(cout3_1)
    );

    assign c3 = cout2;
    wire [15:0] sum3 = c3 ? sum3_1 : sum3_0;
    wire        cout3 = c3 ? cout3_1 : cout3_0;

    assign result = {sum3, sum2, sum1, sum0};

    // Overflow detection for subtraction:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 16-bit Carry Lookahead Adder (CLA)
// Inputs: A, B [15:0], carry-in
// Outputs: sum [15:0], carry-out
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout
);
    wire [15:0] P;  // propagate
    wire [15:0] G;  // generate
    wire [16:0] C;  // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 16; i=i+1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C[16];
endmodule