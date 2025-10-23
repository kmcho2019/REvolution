module full_adder(a, b, c_in, sum, c_out);
    input a, b, c_in;
    output sum, c_out;

    assign sum = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    wire c0, c1, c2;

    full_adder fa0(x[0], y[0], 1'b0, sum[0], c0);
    full_adder fa1(x[1], y[1], c0, sum[1], c1);
    full_adder fa2(x[2], y[2], c1, sum[2], c2);
    full_adder fa3(x[3], y[3], c2, sum[3], sum[4]);
endmodule