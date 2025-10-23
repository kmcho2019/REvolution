module half_adder(
    input  a,
    input  b,
    output sum,
    output carry
);

    assign sum = a ^ b; // Sum is the XOR of a and b
    assign carry = a & b; // Carry is the AND of a and b

endmodule

module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    wire ha_sum;
    wire ha_carry;

    half_adder ha1(
        .a(a),
        .b(b),
        .sum(ha_sum),
        .carry(ha_carry)
    );

    half_adder ha2(
        .a(ha_sum),
        .b(cin),
        .sum(sum),
        .carry(cout)
    );

    // Optional optimization: Directly calculate cout from ha_carry and cin
    // assign cout = ha_carry | (ha_sum & cin);

endmodule