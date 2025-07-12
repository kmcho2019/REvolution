module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Directly select a bit from the input vector based on the sel input
    assign out = in[sel];

endmodule