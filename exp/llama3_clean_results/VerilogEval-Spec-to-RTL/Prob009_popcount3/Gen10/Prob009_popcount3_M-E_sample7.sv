module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Level 1: Consider in[0]
    wire count_1;
    assign count_1 = in[0];

    // Level 2: Consider in[1]
    wire count_2;
    assign count_2 = in[1];

    // Level 3: Consider in[2]
    wire count_3;
    assign count_3 = in[2];

    // Final Count
    assign out[0] = count_1 ^ count_2 ^ count_3;
    assign out[1] = (count_1 & count_2) | (count_1 & count_3) | (count_2 & count_3);

endmodule