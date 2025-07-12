module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Split operands into 4 segments of 16 bits each
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] R_seg [3:0];
    wire        carry [4:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B[15:0];
    assign B_seg[1] = B[31:16];
    assign B_seg[2] = B[47:32];
    assign B_seg[3] = B[63:48];

    // Initial carry-in for subtraction (two's complement addition with +1)
    assign carry[0] = 1'b1;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : sub_16bit_blocks
            sub_16bit_ripple_sub u_sub16 (
                .A     (A_seg[i]),
                .B     (B_seg[i]),
                .cin   (carry[i]),
                .result(R_seg[i]),
                .cout  (carry[i+1])
            );
        end
    endgenerate

    // Concatenate result segments
    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection logic:
    // Overflow occurs if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit ripple carry subtractor using full adders:
// Implements result = A + (~B) + cin
module sub_16bit_ripple_sub (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] result,
    output wire        cout
);
    wire [15:0] B_inv = ~B;
    wire [15:0] sum;
    wire [15:0] carry;

    // First full adder: cin is input carry-in (usually 1 for two's complement subtraction)
    full_adder fa0 (
        .a   (A[0]),
        .b   (B_inv[0]),
        .cin (cin),
        .sum (sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : fa_chain
            full_adder fa (
                .a   (A[i]),
                .b   (B_inv[i]),
                .cin (carry[i-1]),
                .sum (sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign result = sum;
    assign cout = carry[15];

endmodule


// Full adder module
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule