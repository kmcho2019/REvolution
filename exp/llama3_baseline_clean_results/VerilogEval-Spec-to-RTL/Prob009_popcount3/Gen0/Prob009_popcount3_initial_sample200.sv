module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Calculate the count of '1's in the input vector
    assign out[0] = in[0] | in[1] | in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // But the above code does not give the correct count of 1's.
    // A more accurate implementation is:
    wire count_1, count_2, count_3;
    assign count_1 = in[0];
    assign count_2 = in[1];
    assign count_3 = in[2];

    assign out[0] = count_1 ^ count_2 ^ count_3;
    assign out[1] = (count_1 & count_2) | (count_1 & count_3) | (count_2 & count_3);

endmodule