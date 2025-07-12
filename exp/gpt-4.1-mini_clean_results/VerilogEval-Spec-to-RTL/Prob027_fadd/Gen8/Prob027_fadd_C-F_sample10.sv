module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Local function implementing half adder logic
    function [1:0] half_adder;
        input x, y;
        begin
            half_adder[0] = x ^ y; // sum
            half_adder[1] = x & y; // carry
        end
    endfunction

    wire s1;
    wire c1, c2;

    // First half adder: a + b
    assign {c1, s1} = half_adder(a, b);

    // Second half adder: s1 + cin
    assign {c2, sum} = half_adder(s1, cin);

    // Carry out is OR of two carries
    assign cout = c1 | c2;

endmodule