module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_neg;
    wire        carry_out;

    // Two's complement of B: ~B + 1
    sub_64bit_ripple_adder rca_sub (
        .A   (A),
        .B   (~B),
        .cin (1'b1),
        .sum (result),
        .cout(carry_out)
    );

    // Overflow detection:
    // Overflow if sign of A != sign of B and sign of result != sign of A
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);

endmodule

// 64-bit Ripple Carry Adder (simple, small, synthesizable)
module sub_64bit_ripple_adder (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);

    wire [63:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : full_adder_bits
            full_adder fa (
                .a   (A[i]),
                .b   (B[i]),
                .cin (carry[i]),
                .sum (sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[64];

endmodule

// 1-bit Full Adder
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule