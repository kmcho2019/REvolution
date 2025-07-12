module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Use the select signal to index into the 256-bit input vector
    assign out = in[sel];

endmodule