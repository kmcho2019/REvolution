// Define the 4-bit adder module
module Adder4Bit(
    input  [3:0] a,  
    input  [3:0] b,  
    input        cin,  
    output [3:0] sum,  
    output       cout  
);

    // Internal wires for the adder
    wire [3:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = cin;

    // Calculate the carry bits using lookahead logic
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);

    // Calculate the sum bits using the carry bits
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign sum[3] = a[3] ^ b[3] ^ carry[3];

    // Calculate the carry-out
    assign cout = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    // Simplified logic for detecting overflow
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the adders and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [3:0] sum_lower;
    wire [3:0] sum_upper;
    wire       cout_lower;

    // Add the lower 4 bits
    Adder4Bit adder_lower(
      .a(a[3:0]),
      .b(b[3:0]),
      .cin(1'b0),
      .sum(sum_lower),
      .cout(cout_lower)
    );

    // Add the upper 4 bits with carry-in from lower 4-bit adder
    Adder4Bit adder_upper(
      .a(a[7:4]),
      .b(b[7:4]),
      .cin(cout_lower),
      .sum(sum_upper),
      .cout()
    );

    // Combine the results
    assign s[3:0] = sum_lower;
    assign s[7:4] = sum_upper;

    // Detect overflow
    OverflowDetector detector(
      .a(a),
      .b(b),
      .sum(s),
      .overflow(overflow)
    );

endmodule