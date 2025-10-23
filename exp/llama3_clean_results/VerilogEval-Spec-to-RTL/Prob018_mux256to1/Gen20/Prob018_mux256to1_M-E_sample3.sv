module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Generate a mask with a '1' at the position indicated by the select signal
    wire [255:0] mask;
    assign mask = (1 << sel);

    // Use the mask to select the desired bit from the input vector
    assign out = (in & mask) != 0;

endmodule