module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Use a single, large multiplexer to select one bit from the input vector
    assign out = in[sel];

endmodule