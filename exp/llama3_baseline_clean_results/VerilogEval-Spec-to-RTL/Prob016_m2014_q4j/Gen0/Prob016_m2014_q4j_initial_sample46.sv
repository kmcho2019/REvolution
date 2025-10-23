module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // Internal signals for carry
    wire c0, c1, c2, c3;

    // Full adder for bit 0
    full_adder fa0(x[0], y[0], 1'b0, sum[0], c0);

    // Full adder for bit 1
    full_adder fa1(x[1], y[1], c0, sum[1], c1);

    // Full adder for bit 2
    full_adder fa2(x[2], y[2], c1, sum[2], c2);

    // Full adder for bit 3
    full_adder fa3(x[3], y[3], c2, sum[3], c3);

    // Assign overflow bit
    assign sum[4] = c3;
endmodule

// Full adder module
module full_adder(a, b, cin, sum, cout);
    input a;
    input b;
    input cin;
    output sum;
    output cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule