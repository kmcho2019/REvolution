module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate sum: number of set bits in 'in'
    // Range: 0 to 3, so 2 bits suffice
    wire [1:0] sum;
    assign sum = in[0] + in[1] + in[2];

    // The population count bits can be directly derived as:
    // out[0] = parity of inputs (LSB of sum)
    // out[1] = majority of inputs (MSB of sum)
    // Using explicit minimal logic expressions from Example 2:
    assign out[0] = in[0] ^ in[1] ^ in[2]; // parity (LSB)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]); // majority (MSB)

    // Note: sum[1:0] equals out[1:0], but expressing outputs explicitly via logic reduces gate count

endmodule