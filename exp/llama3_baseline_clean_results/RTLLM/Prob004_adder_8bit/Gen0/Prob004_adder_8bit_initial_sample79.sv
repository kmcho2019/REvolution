module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input cin,      // Carry-in input
    output [7:0] sum,  // 8-bit output representing the sum of A and B
    output cout      // Carry-out output
);

    // Internal wire to hold the carry-out from each full adder
    wire [7:0] carry;

    // Perform bit-level addition using full adders
    // The first full adder's carry-in is the module's cin
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Subsequent full adders use the previous full adder's carry-out as their carry-in
    full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], sum[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], sum[7], carry[7]);

    // The module's carry-out is the carry-out of the last full adder
    assign cout = carry[7];
endmodule

// Full adder module
module full_adder(
    input a,      // Input bit A
    input b,      // Input bit B
    input cin,    // Carry-in input
    output sum,   // Sum output
    output cout   // Carry-out output
);
    // Calculate sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule