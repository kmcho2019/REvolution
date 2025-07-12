module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Use bitwise indexing to select the desired bit from the input vector
    assign out = (in >> sel) & 1'b1;

endmodule