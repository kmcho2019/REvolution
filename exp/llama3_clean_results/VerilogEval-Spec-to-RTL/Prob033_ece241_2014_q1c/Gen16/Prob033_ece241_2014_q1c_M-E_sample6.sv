// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the 4-bit ripple-carry adder module
module ripple_carry_adder(
    input  [3:0] a,  
    input  [3:0] b,  
    input  cin,  
    output [3:0] sum,  
    output cout  
);

    wire [2:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = cin;

    full_adder fa0(
       .a(a[0]),
       .b(b[0]),
       .cin(carry[0]),
       .sum(sum[0]),
       .cout(carry[1])
    );

    full_adder fa1(
       .a(a[1]),
       .b(b[1]),
       .cin(carry[1]),
       .sum(sum[1]),
       .cout(carry[2])
    );

    full_adder fa2(
       .a(a[2]),
       .b(b[2]),
       .cin(carry[2]),
       .sum(sum[2]),
       .cout(carry[3])
    );

    full_adder fa3(
       .a(a[3]),
       .b(b[3]),
       .cin(carry[3]),
       .sum(sum[3]),
       .cout(cout)
    );

endmodule

// Define the carry-lookahead logic module
module carry_lookahead(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] carry  
);

    assign carry[0] = a[0] & b[0];
    assign carry[1] = (a[0] & b[1]) | (a[1] & b[0]) | (a[0] & b[0]);
    assign carry[2] = (a[0] & b[2]) | (a[1] & b[1]) | (a[2] & b[0]) | (a[0] & b[1]) | (a[1] & b[0]) | (a[0] & b[0]);
    assign carry[3] = (a[0] & b[3]) | (a[1] & b[2]) | (a[2] & b[1]) | (a[3] & b[0]) | (a[0] & b[2]) | (a[1] & b[1]) | (a[2] & b[0]) | (a[0] & b[1]) | (a[1] & b[0]) | (a[0] & b[0]);

endmodule

// Define the hybrid adder module
module hybrid_adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output cout  
);

    wire [3:0] carry;
    wire [3:0] sum1;
    wire [3:0] sum2;

    carry_lookahead cl(
       .a(a[3:0]),
       .b(b[3:0]),
       .carry(carry)
    );

    ripple_carry_adder rca1(
       .a(a[3:0]),
       .b(b[3:0]),
       .cin(1'b0),
       .sum(sum1),
       .cout(carry[3])
    );

    ripple_carry_adder rca2(
       .a(a[7:4]),
       .b(b[7:4]),
       .cin(carry[3]),
       .sum(sum2),
       .cout(cout)
    );

    assign sum[3:0] = sum1;
    assign sum[7:4] = sum2;

endmodule

// Define the overflow detection module
module overflow_detector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire cout;

    hybrid_adder ha(
       .a(a),
       .b(b),
       .sum(s),
       .cout(cout)
    );

    overflow_detector od(
       .a(a),
       .b(b),
       .sum(s),
       .overflow(overflow)
    );

endmodule