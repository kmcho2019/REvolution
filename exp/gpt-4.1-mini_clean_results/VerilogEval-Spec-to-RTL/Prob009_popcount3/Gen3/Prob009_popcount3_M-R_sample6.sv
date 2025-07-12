module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate wire holding the bit count (population count)
    wire [2:0] bit_count;

    // Count the number of set bits by summing individual bits
    assign bit_count = in[0] + in[1] + in[2];

    // Assign the lower two bits of bit_count to output
    assign out = bit_count[1:0];

endmodule