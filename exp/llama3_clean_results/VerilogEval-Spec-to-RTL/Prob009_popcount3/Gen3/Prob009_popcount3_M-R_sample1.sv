module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] ones_count;
    wire count0, count1, count2;

    assign count0 = (in[0] == 1) ? 1 : 0;
    assign count1 = (in[1] == 1) ? 1 : 0;
    assign count2 = (in[2] == 1) ? 1 : 0;

    assign ones_count[0] = count0 ^ count1 ^ count2;
    assign ones_count[1] = (count0 & count1) | (count1 & count2) | (count2 & count0);

    assign out = ones_count;

endmodule