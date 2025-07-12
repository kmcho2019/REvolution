// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the 8-bit ripple-carry adder module
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the ripple-carry adder
    wire [7:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = 1'b0;

    // Ripple-carry adder for each bit position
    full_adder fa0(a[0], b[0], carry[0], sum[0], carry[1]);
    full_adder fa1(a[1], b[1], carry[1], sum[1], carry[2]);
    full_adder fa2(a[2], b[2], carry[2], sum[2], carry[3]);
    full_adder fa3(a[3], b[3], carry[3], sum[3], carry[4]);
    full_adder fa4(a[4], b[4], carry[4], sum[4], carry[5]);
    full_adder fa5(a[5], b[5], carry[5], sum[5], carry[6]);
    full_adder fa6(a[6], b[6], carry[6], sum[6], carry[7]);
    full_adder fa7(a[7], b[7], carry[7], sum[7], );

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    EightBitAdder adder(
       .a(a),
       .b(b),
       .sum(sum)
    );

    OverflowDetector detector(
       .a(a),
       .b(b),
       .sum(sum),
       .overflow(overflow)
    );

    assign s = sum;

endmodule