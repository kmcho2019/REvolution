module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire count;
    assign count = in[0] + in[1] + in[2];
    assign out[0] = count[0];
    assign out[1] = count[1];

endmodule