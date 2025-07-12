// Single-bit full adder with minimized logic and no intermediate wires
module bit_full_adder (
    input  wire a,       // single-bit input A
    input  wire b,       // single-bit input B
    input  wire cin,     // carry-in input
    output wire sum,     // sum output
    output wire cout     // carry-out output
);
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;
    // Carry-out is majority function of inputs
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// Half adder module for the least significant bit to simplify logic
module half_adder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// 8-bit ripple carry adder using explicit instantiations for better synthesis optimization
module adder_8bit (
    input  wire [7:0] a,     // 8-bit input operand A
    input  wire [7:0] b,     // 8-bit input operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire c1, c2, c3, c4, c5, c6, c7;  // Internal carry signals

    // First bit uses half adder and incorporates external carry-in
    wire sum0_partial, c0_partial;
    half_adder ha0 (
        .a(a[0]),
        .b(b[0]),
        .sum(sum0_partial),
        .cout(c0_partial)
    );
    assign sum[0] = sum0_partial ^ cin;      // sum0 = HA_sum ^ cin
    assign c1 = (sum0_partial & cin) | c0_partial; // carry to bit 1

    // Remaining bits are full adders with carry chain
    bit_full_adder fa1 (
        .a(a[1]), .b(b[1]), .cin(c1),
        .sum(sum[1]), .cout(c2)
    );
    bit_full_adder fa2 (
        .a(a[2]), .b(b[2]), .cin(c2),
        .sum(sum[2]), .cout(c3)
    );
    bit_full_adder fa3 (
        .a(a[3]), .b(b[3]), .cin(c3),
        .sum(sum[3]), .cout(c4)
    );
    bit_full_adder fa4 (
        .a(a[4]), .b(b[4]), .cin(c4),
        .sum(sum[4]), .cout(c5)
    );
    bit_full_adder fa5 (
        .a(a[5]), .b(b[5]), .cin(c5),
        .sum(sum[5]), .cout(c6)
    );
    bit_full_adder fa6 (
        .a(a[6]), .b(b[6]), .cin(c6),
        .sum(sum[6]), .cout(c7)
    );
    bit_full_adder fa7 (
        .a(a[7]), .b(b[7]), .cin(c7),
        .sum(sum[7]), .cout(cout)
    );

endmodule