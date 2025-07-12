// Define a module for a full adder
module full_adder(
    input   logic       a,
    input   logic       b,
    input   logic       cin,
    output  logic       sum,
    output  logic       cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for an 8-bit adder
module adder_8bit(
    input   logic [7:0]  a,
    input   logic [7:0]  b,
    input   logic        cin,
    output  logic [7:0]  y,
    output  logic        co
);
    logic [7:0]  sum;
    logic [8:0]  carry;

    // Use a full adder for each bit
    full_adder fa0(a[0], b[0], cin, sum[0], carry[1]);
    full_adder fa1(a[1], b[1], carry[1], sum[1], carry[2]);
    full_adder fa2(a[2], b[2], carry[2], sum[2], carry[3]);
    full_adder fa3(a[3], b[3], carry[3], sum[3], carry[4]);
    full_adder fa4(a[4], b[4], carry[4], sum[4], carry[5]);
    full_adder fa5(a[5], b[5], carry[5], sum[5], carry[6]);
    full_adder fa6(a[6], b[6], carry[6], sum[6], carry[7]);
    full_adder fa7(a[7], b[7], carry[7], sum[7], carry[8]);

    assign y = sum;
    assign co = carry[8];
endmodule

// Define the 16-bit adder module
module adder_16bit(
    input   logic [15:0]  a,
    input   logic [15:0]  b,
    input   logic         cin,
    output  logic [15:0]  y,
    output  logic         co
);
    logic                carry8;

    // Instantiate two 8-bit adders
    adder_8bit adder_low(a[7:0], b[7:0], cin, y[7:0], carry8);
    adder_8bit adder_high(a[15:8], b[15:8], carry8, y[15:8], co);
endmodule