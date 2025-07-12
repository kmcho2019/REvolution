module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Direct selection using the sel signal
    assign out = in[sel];

endmodule