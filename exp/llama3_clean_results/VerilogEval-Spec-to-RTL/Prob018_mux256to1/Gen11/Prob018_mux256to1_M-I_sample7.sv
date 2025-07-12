module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Direct selection based on the select signal
    assign out = in[sel];

endmodule