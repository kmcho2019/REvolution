module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire partial_sum;
    wire carry_ab, carry_bc, carry_ac;

    assign partial_sum = a ^ b;
    assign sum = partial_sum ^ cin;

    assign carry_ab = a & b;
    assign carry_bc = b & cin;
    assign carry_ac = a & cin;

    assign cout = carry_ab | carry_bc | carry_ac;
endmodule