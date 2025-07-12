// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Full adder logic: sum and carry out
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

// 8-bit adder with bit-level full adders and explicit carry lookahead logic
module adder_8bit (
    input  wire [7:0] a,    // Operand A
    input  wire [7:0] b,    // Operand B
    input  wire       cin,  // Carry-in
    output wire [7:0] sum,  // Sum output
    output wire       cout  // Carry-out
);
    // Propagate and generate vectors
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Carry vector: carry[0] = cin; carry[8] = cout
    wire [8:0] carry;

    assign carry[0] = cin;

    // Explicit carry lookahead computation (unrolled for clarity)
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = g[3] | (p[3] & carry[3]);
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    assign carry[8] = g[7] | (p[7] & carry[7]);

    // Generate block to instantiate 8 bit-level full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_bits
            bit_full_adder fa_inst (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i]),
                .sum  (sum[i]),
                .cout ()      // Internal carry outputs unused as carry chain computed separately
            );
        end
    endgenerate

    assign cout = carry[8];

endmodule