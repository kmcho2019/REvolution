module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire temp;
    assign temp = in[0] + in[1];
    assign out = {temp + in[2], temp};

endmodule