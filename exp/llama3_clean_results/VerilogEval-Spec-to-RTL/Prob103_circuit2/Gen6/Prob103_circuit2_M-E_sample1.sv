module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Half-adder module
module half_adder(
    input  a,
    input  b,
    output sum,
    output carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Instantiate half-adders to count the number of 1s
wire sum1, carry1, sum2, carry2, final_carry;
half_adder ha1(a, b, sum1, carry1);
half_adder ha2(c, d, sum2, carry2);
half_adder ha3(sum1, sum2, , final_carry);

// Use the carry from the last half-adder to determine q
assign q = ~final_carry;

endmodule