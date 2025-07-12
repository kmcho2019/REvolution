module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum0, carry0;
    wire sum1, carry1;

    // Add in[0] + in[1]
    assign sum0 = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];

    // Add sum0 + in[2]
    assign sum1 = sum0 ^ in[2];
    assign carry1 = sum0 & in[2];

    // Output is 2 bits: LSB is sum1, MSB is carry0 + carry1 (or)
    assign out[0] = sum1;
    assign out[1] = carry0 | carry1;

endmodule