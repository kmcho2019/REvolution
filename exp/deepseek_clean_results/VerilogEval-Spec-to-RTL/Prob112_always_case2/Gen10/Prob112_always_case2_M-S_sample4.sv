module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    assign pos[1] = in[3] | (in[2] & ~in[3]);
    assign pos[0] = in[1] | (in[3] & ~(&in[1:0]));

endmodule