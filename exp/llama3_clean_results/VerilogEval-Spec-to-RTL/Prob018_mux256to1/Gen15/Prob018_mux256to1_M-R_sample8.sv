module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 16 groups of 16 bits and select one group using the most significant 4 bits of the select signal
    assign out = in[(sel[7:4]*16) + sel[3:0]];

endmodule