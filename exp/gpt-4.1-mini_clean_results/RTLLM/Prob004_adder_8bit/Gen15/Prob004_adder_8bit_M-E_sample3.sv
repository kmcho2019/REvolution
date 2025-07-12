// 1-bit full adder module
module full_adder_1bit (
    input  wire a,    // 1-bit input A
    input  wire b,    // 1-bit input B
    input  wire cin,  // Carry-in
    output wire sum,  // Sum output
    output wire cout  // Carry-out
);
    // Sum is XOR of inputs and carry-in
    assign sum = a ^ b ^ cin;
    // Carry-out is generated if two or more inputs are 1
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit ripple carry adder composed of 8 full adders
module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // Carry-out output
);
    wire [7:0] c;  // Internal carry wires between full adders

    // Instantiate 8 full adders in a ripple carry chain
    full_adder_1bit fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c[0])
    );
    full_adder_1bit fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .cout(c[1])
    );
    full_adder_1bit fa2 (
        .a(a[2]),
        .b(b[2]),
        .cin(c[1]),
        .sum(sum[2]),
        .cout(c[2])
    );
    full_adder_1bit fa3 (
        .a(a[3]),
        .b(b[3]),
        .cin(c[2]),
        .sum(sum[3]),
        .cout(c[3])
    );
    full_adder_1bit fa4 (
        .a(a[4]),
        .b(b[4]),
        .cin(c[3]),
        .sum(sum[4]),
        .cout(c[4])
    );
    full_adder_1bit fa5 (
        .a(a[5]),
        .b(b[5]),
        .cin(c[4]),
        .sum(sum[5]),
        .cout(c[5])
    );
    full_adder_1bit fa6 (
        .a(a[6]),
        .b(b[6]),
        .cin(c[5]),
        .sum(sum[6]),
        .cout(c[6])
    );
    full_adder_1bit fa7 (
        .a(a[7]),
        .b(b[7]),
        .cin(c[6]),
        .sum(sum[7]),
        .cout(cout)
    );

endmodule