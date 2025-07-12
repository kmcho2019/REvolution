module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Local function for half adder sum
    function half_sum(input x, input y);
        half_sum = x ^ y;
    endfunction

    // Local function for half adder carry
    function half_carry(input x, input y);
        half_carry = x & y;
    endfunction

    wire sum1, carry1, carry2;

    assign sum1 = half_sum(a, b);
    assign carry1 = half_carry(a, b);

    assign sum = half_sum(sum1, cin);
    assign carry2 = half_carry(sum1, cin);

    assign cout = carry1 | carry2;
endmodule