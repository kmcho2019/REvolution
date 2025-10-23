module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output out // 1-bit output
);

    // Use the sel signal to index into the input vector and select the output
    // This is a 256-to-1 multiplexer, where sel=0 selects in[0], sel=1 selects in[1], etc.
    assign out = in[sel];

endmodule