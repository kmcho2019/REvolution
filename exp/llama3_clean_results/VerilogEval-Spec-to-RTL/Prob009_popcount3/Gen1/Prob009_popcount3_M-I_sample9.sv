module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire count0, count1;

    assign count0 = in[0] ^ in[1];
    assign count1 = count0 ^ in[2];

    assign out[0] = count0 ^ count1;
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule