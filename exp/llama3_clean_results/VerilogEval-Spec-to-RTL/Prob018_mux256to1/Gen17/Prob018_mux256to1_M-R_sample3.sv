module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Directly select the desired bit from the input vector based on the sel signal
    assign out = in[sel];

endmodule