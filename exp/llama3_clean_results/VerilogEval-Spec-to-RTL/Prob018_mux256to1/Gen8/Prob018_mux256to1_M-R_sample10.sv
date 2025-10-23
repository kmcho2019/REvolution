module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Directly index into the in vector based on the sel value
    assign out = in[sel];

endmodule