module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the index of the desired bit within the input vector
    assign out = in[(sel[7:4] * 16) + sel[3:0]];

endmodule