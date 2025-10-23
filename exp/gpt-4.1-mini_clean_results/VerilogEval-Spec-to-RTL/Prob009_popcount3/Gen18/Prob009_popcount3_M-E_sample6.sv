module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum1, carry1;
    wire sum2, carry2;

    // First half adder: sum and carry of in[0] and in[1]
    assign sum1 = in[0] ^ in[1];
    assign carry1 = in[0] & in[1];

    // Second half adder: add sum1 and in[2]
    assign sum2 = sum1 ^ in[2];
    assign carry2 = sum1 & in[2];

    // Final output: LSB is sum2, MSB is carry from both adders
    assign out[0] = sum2;
    assign out[1] = carry1 | carry2;

endmodule