module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire sum1, cout1, cout2;

    // Half adder logic inlined as wires (sum = x ^ y; cout = x & y)
    assign sum1 = a ^ b;
    assign cout1 = a & b;
    assign sum = sum1 ^ cin;
    assign cout2 = sum1 & cin;
    assign cout = cout1 | cout2;

endmodule