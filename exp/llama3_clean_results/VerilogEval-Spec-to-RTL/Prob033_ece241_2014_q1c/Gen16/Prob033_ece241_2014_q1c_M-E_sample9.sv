// Define the ripple-carry adder module
module RippleCarryAdder(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] sum,  
    output      cout  
);

    // Internal wires for the ripple-carry adder
    wire [2:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = 1'b0;

    // Calculate the sum and carry bits using full adders
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);

    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);

    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign cout = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

endmodule

// Define the carry-lookahead adder module
module CarryLookaheadAdder(
    input  [3:0] a,  
    input  [3:0] b,  
    input      cin,  
    output [3:0] sum,  
    output      cout  
);

    // Internal wires for the carry-lookahead adder
    wire [3:0] carry;

    // Calculate the carry bits using lookahead logic
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);

    // Calculate the sum bits using the carry bits
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ carry[0];
    assign sum[2] = a[2] ^ b[2] ^ carry[1];
    assign sum[3] = a[3] ^ b[3] ^ carry[2];

    assign cout = carry[3];

endmodule

// TopModule that integrates the adders and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [3:0] sum_low;
    wire      cout_low;
    wire [3:0] sum_high;
    wire      cout_high;

    RippleCarryAdder adder_low(
        .a(a[3:0]),
        .b(b[3:0]),
        .sum(sum_low),
        .cout(cout_low)
    );

    CarryLookaheadAdder adder_high(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(cout_low),
        .sum(sum_high),
        .cout(cout_high)
    );

    // Overflow detection logic integrated into the TopModule
    assign overflow = (a[7] == b[7] && a[7] != sum_high[3]);
    assign s[3:0] = sum_low;
    assign s[7:4] = sum_high;

endmodule