module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // Internal wire to carry the carry bit between full adders
    wire [2:0] carry;

    // First full adder for the least significant bit
    full_adder fa0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .s(sum[0]),
       .cout(carry[0])
    );

    // Second full adder for the second least significant bit
    full_adder fa1(
       .a(x[1]),
       .b(y[1]),
       .cin(carry[0]),
       .s(sum[1]),
       .cout(carry[1])
    );

    // Third full adder for the third least significant bit
    full_adder fa2(
       .a(x[2]),
       .b(y[2]),
       .cin(carry[1]),
       .s(sum[2]),
       .cout(carry[2])
    );

    // Fourth full adder for the most significant bit
    full_adder fa3(
       .a(x[3]),
       .b(y[3]),
       .cin(carry[2]),
       .s(sum[3]),
       .cout(sum[4])
    );

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output cout
);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule