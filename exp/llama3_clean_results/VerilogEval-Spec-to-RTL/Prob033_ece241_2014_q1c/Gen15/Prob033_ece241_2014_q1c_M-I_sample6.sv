// Define the full adder module with optimized logic for lower power consumption
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out using optimized logic
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the carry-lookahead adder module
module CarryLookaheadAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the carry-lookahead adder
    wire [7:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = 1'b0;

    // Calculate the carry bits using lookahead logic
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);
    assign carry[5] = (a[4] & b[4]) | (a[4] & carry[4]) | (b[4] & carry[4]);
    assign carry[6] = (a[5] & b[5]) | (a[5] & carry[5]) | (b[5] & carry[5]);
    assign carry[7] = (a[6] & b[6]) | (a[6] & carry[6]) | (b[6] & carry[6]);

    // Calculate the sum bits using the carry bits
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign sum[4] = a[4] ^ b[4] ^ carry[4];
    assign sum[5] = a[5] ^ b[5] ^ carry[5];
    assign sum[6] = a[6] ^ b[6] ^ carry[6];
    assign sum[7] = a[7] ^ b[7] ^ carry[7];

endmodule

// Define the overflow detection module with optimized logic
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    // Simplified logic for detecting overflow
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

    CarryLookaheadAdder adder(
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