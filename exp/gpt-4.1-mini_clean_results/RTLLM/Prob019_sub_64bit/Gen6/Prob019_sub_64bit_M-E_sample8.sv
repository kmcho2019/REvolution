module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_inv = ~B;    // bitwise inversion of B
    wire [63:0] sum;
    wire carry_out;

    // Ripple Carry Adder for 64-bit: sum = A + B_inv + 1
    // Implement bitwise full adders chained with carry
    wire [63:0] carry;
    
    // First bit add with carry_in = 1 (for two's complement)
    full_adder fa0 (
        .a   (A[0]),
        .b   (B_inv[0]),
        .cin (1'b1),
        .sum (sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin : bit_adders
            full_adder fa (
                .a   (A[i]),
                .b   (B_inv[i]),
                .cin (carry[i-1]),
                .sum (sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign carry_out = carry[63];
    assign result = sum;

    // Overflow detection:
    // For subtraction A - B, overflow occurs if:
    // (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

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