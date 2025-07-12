module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // First full adder
    wire sum1, carry1;
    full_adder fa1(in[0], in[1], 1'b0, sum1, carry1);

    // Second full adder
    wire sum2, carry2;
    full_adder fa2(sum1, in[2], carry1, sum2, carry2);

    // Assign the output
    assign out[0] = sum2;
    assign out[1] = carry2;

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule