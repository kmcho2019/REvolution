module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // internal carry signals
    wire c1, c2, c3;

    // first full adder (least significant bit)
    full_adder fa0(x[0], y[0], 1'b0, sum[0], c1);

    // second full adder
    full_adder fa1(x[1], y[1], c1, sum[1], c2);

    // third full adder
    full_adder fa2(x[2], y[2], c2, sum[2], c3);

    // fourth full adder (most significant bit)
    full_adder fa3(x[3], y[3], c3, sum[3], sum[4]);

endmodule

// full adder module
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule