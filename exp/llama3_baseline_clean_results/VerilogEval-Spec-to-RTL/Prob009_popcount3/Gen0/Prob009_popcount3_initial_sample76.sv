module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Half adder to add the first two bits
    wire sum0, carry0;
    assign sum0 = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];

    // Half adder to add the result with the third bit
    wire sum1, carry1;
    assign sum1 = sum0 ^ in[2];
    assign carry1 = (sum0 & in[2]) | (carry0 & (in[2] | sum0));

    // Assign the output
    assign out[0] = sum1;
    assign out[1] = carry1;

endmodule