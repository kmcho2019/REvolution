// Define the module for a 4-bit carry-save adder
module adder_4bit_cs(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output [3:0] carry
);

    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);

    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);

    assign sum[3] = a[3] ^ b[3] ^ carry[2];
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);

endmodule

// Define the module for a 16-bit carry-save adder
module adder_16bit_cs(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] sum,
    output Co
);

    wire [3:0] carry1, carry2, carry3;
    wire [15:0] sum1, sum2, sum3;

    // Segment 1 (bits 3:0)
    adder_4bit_cs adder1(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum1[3:0]),
        .carry(carry1)
    );

    // Segment 2 (bits 7:4)
    adder_4bit_cs adder2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry1[3]),
        .sum(sum2[3:0]),
        .carry(carry2)
    );

    // Segment 3 (bits 11:8)
    adder_4bit_cs adder3(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry2[3]),
        .sum(sum3[3:0]),
        .carry(carry3)
    );

    // Segment 4 (bits 15:12)
    adder_4bit_cs adder4(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry3[3]),
        .sum(sum[15:12]),
        .carry(Co)
    );

    // Combine the segments
    assign sum[11:8] = sum3;
    assign sum[7:4] = sum2;
    assign sum[3:0] = sum1;

endmodule