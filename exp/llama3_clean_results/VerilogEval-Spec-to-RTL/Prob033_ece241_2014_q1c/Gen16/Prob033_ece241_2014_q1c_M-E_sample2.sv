// Define the 4-bit ripple-carry adder module
module ripple_carry_adder(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] sum,  
    output      cout  
);

    wire [3:0] carry;

    // Initialize the carry-in for the LSB
    assign carry[0] = 1'b0;

    // Calculate the sum and carry bits using ripple-carry logic
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign cout = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);

endmodule

// Define the 8-bit hybrid adder module
module hybrid_adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      cout  
);

    wire [3:0] sum_high;
    wire [3:0] sum_low;
    wire cout_low;
    wire cout_high;

    // Split the 8-bit addition into two 4-bit additions
    ripple_carry_adder adder_low(
        .a(a[3:0]),
        .b(b[3:0]),
        .sum(sum_low),
        .cout(cout_low)
    );

    ripple_carry_adder adder_high(
        .a(a[7:4]),
        .b(b[7:4]),
        .sum(sum_high),
        .cout(cout_high)
    );

    // Combine the results using a carry-lookahead approach
    assign sum[3:0] = sum_low;
    assign sum[7:4] = sum_high;
    assign cout = (cout_low & a[3] & b[3]) | (cout_high & a[7] & b[7]);

endmodule

// Define the overflow detection module
module overflow_detector(
    input  a_sign,  // sign bit of operand a
    input  b_sign,  // sign bit of operand b
    input  sum_sign,  // sign bit of the result
    output      overflow  
);

    assign overflow = (a_sign == b_sign && a_sign != sum_sign);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;
    wire cout;

    hybrid_adder adder(
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

    overflow_detector detector(
        .a_sign(a[7]),
        .b_sign(b[7]),
        .sum_sign(sum[7]),
        .overflow(overflow)
    );

    assign s = sum;

endmodule