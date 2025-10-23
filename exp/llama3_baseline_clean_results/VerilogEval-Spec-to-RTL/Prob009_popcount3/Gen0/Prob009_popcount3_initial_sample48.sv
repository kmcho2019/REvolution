module TopModule(in, out);
    input [2:0] in;
    output [1:0] out;

    // internal wire to hold the sum of the first two input bits
    wire [1:0] sum1;

    // first full adder
    full_adder fa1(in[0], in[1], 1'b0, sum1, 1'b0);

    // second full adder
    full_adder fa2(sum1[0], in[2], sum1[1], out[0], out[1]);

endmodule

// definition of full adder module
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule