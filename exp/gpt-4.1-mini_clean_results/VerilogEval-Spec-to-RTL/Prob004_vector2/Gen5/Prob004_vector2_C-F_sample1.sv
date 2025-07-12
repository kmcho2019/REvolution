module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Directly assign the output by reversing the bytes via slicing,
    // without intermediate wires for minimal overhead and clear intent.
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule