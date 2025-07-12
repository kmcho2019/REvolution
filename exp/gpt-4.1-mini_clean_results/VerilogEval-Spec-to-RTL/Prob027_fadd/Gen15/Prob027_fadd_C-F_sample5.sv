module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Inline half adder function for sum
    function half_sum;
        input x, y;
        begin
            half_sum = x ^ y;
        end
    endfunction

    // Inline half adder function for carry
    function half_cout;
        input x, y;
        begin
            half_cout = x & y;
        end
    endfunction

    wire sum1, cout1, cout2;

    assign sum1 = half_sum(a, b);
    assign cout1 = half_cout(a, b);
    assign sum = half_sum(sum1, cin);
    assign cout2 = half_cout(sum1, cin);
    assign cout = cout1 | cout2;

endmodule