module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Direct binary decoding to select the desired bit
    assign out = in[sel];

endmodule