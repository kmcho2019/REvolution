module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute ~B for two's complement subtraction
    wire [63:0] B_neg = ~B;

    // Divide operands and complemented B into 16-bit chunks
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];

    wire [15:0] B0 = B_neg[15:0];
    wire [15:0] B1 = B_neg[31:16];
    wire [15:0] B2 = B_neg[47:32];
    wire [15:0] B3 = B_neg[63:48];

    // Intermediate sum outputs and carry chains
    wire [15:0] R0, R1, R2, R3;
    wire c1, c2, c3, c4;

    // Initial carry-in = 1 for adding the +1 in two's complement
    // Chain four 16-bit carry-lookahead adders for A + (~B) + 1
    cla_16bit u_cla0(.A(A0), .B(B0), .cin(1'b1),  .sum(R0), .cout(c1));
    cla_16bit u_cla1(.A(A1), .B(B1), .cin(c1),   .sum(R1), .cout(c2));
    cla_16bit u_cla2(.A(A2), .B(B2), .cin(c2),   .sum(R2), .cout(c3));
    cla_16bit u_cla3(.A(A3), .B(B3), .cin(c3),   .sum(R3), .cout(c4));

    assign result = {R3, R2, R1, R0};

    // Overflow detection logic:
    // Overflow occurs if sign of A and B differ, and sign of result differs from A's sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit Carry Lookahead Adder
// Computes sum = A + B + cin with carry out cout
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout
);
    wire [15:0] P; // Propagate signals
    wire [15:0] G; // Generate signals
    wire [16:0] C; // Carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // Carry lookahead per bit
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C[16];

endmodule