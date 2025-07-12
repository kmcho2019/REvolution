module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum0;
    wire carry0;
    wire [1:0] bit_count;

    // Half-adder: sum and carry of in[0] and in[1]
    assign sum0 = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];

    // Add in[2] to sum0: sum bit and carry bit
    assign bit_count[0] = sum0 ^ in[2];
    assign bit_count[1] = carry0 | (sum0 & in[2]);

    // Assign the 2-bit population count to output
    assign out = bit_count;

endmodule