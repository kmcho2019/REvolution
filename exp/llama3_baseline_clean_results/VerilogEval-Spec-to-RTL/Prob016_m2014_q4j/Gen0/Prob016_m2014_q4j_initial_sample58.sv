module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    wire c1, c2, c3;

    // First full adder for bits 0 of x and y
    full_adder fa1(x[0], y[0], 1'b0, sum[0], c1);

    // Second full adder for bits 1 of x and y
    full_adder fa2(x[1], y[1], c1, sum[1], c2);

    // Third full adder for bits 2 of x and y
    full_adder fa3(x[2], y[2], c2, sum[2], c3);

    // Fourth full adder for bits 3 of x and y
    full_adder fa4(x[3], y[3], c3, sum[3], sum[4]);

endmodule

module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule