// Full Adder module: computes sum and carry-out from two inputs and carry-in
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

// 8-bit ripple carry adder using 8 full adder instances
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    // First bit full adder
    full_adder fa0 (
        .a    (a[0]),
        .b    (b[0]),
        .cin  (cin),
        .sum  (sum[0]),
        .cout (carry[0])
    );

    // Bits 1 to 6
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : gen_fa
            full_adder fa (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i-1]),
                .sum  (sum[i]),
                .cout (carry[i])
            );
        end
    endgenerate

    // Most significant bit full adder
    full_adder fa7 (
        .a    (a[7]),
        .b    (b[7]),
        .cin  (carry[6]),
        .sum  (sum[7]),
        .cout (cout)
    );
endmodule