module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Define wires to hold intermediate results
    wire [1:0] count_1;
    wire [1:0] count_2;

    // Use bit comparators to compare input bits in pairs
    assign count_1[0] = in[0] | in[1];
    assign count_1[1] = in[0] & in[1];

    // Use intermediate counters to store intermediate results
    assign count_2[0] = count_1[0] | in[2];
    assign count_2[1] = count_1[1] & in[2];

    // Use final counter to generate the final 2-bit output
    assign out[0] = count_2[0];
    assign out[1] = count_2[1];

endmodule