module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector
);

    // Count the number of '1's in the most significant two bits
    wire [1:0] count_high;
    assign count_high[0] = in[2] | in[1];
    assign count_high[1] = in[2] & in[1];

    // Add the value of the least significant bit
    assign out[0] = count_high[0] ^ in[0];
    assign out[1] = count_high[1] | (count_high[0] & in[0]);

endmodule