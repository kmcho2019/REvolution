module TopModule(
    input [2:0] in,
    output [1:0] out
);

    assign out = (in[0] ? 1 : 0) + (in[1] ? 1 : 0) + (in[2] ? 1 : 0);

endmodule