module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Count '1's in in[0] and in[1]
    wire count_01;
    assign count_01 = in[0] ^ in[1];

    // Count '1's in in[0] and in[1] and in[2]
    assign out[0] = in[0] | in[1] | in[2];
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

endmodule