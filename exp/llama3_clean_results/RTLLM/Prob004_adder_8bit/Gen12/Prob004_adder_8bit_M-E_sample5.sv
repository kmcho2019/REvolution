// Define a module for a 1-bit full adder
module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit adder using full adders
module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    wire [2:0] c; // Internal carry signals

    // Instantiate full adders
    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    full_adder fa1(a[1], b[1], c[0], sum[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], sum[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], sum[3], cout);
endmodule

// Define the module for an 8-bit adder using two 4-bit adders
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    wire c4; // Carry from the first 4-bit adder to the second

    // Instantiate two 4-bit adders
    adder_4bit adder_lo(a[3:0], b[3:0], cin, sum[3:0], c4);
    adder_4bit adder_hi(a[7:4], b[7:4], c4, sum[7:4], cout);
endmodule