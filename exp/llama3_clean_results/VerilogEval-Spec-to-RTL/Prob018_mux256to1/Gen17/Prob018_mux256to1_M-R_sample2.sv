module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the offset of the desired bit within the input vector
    wire [7:0] offset = {sel[7:4], sel[3:0]};

    // Directly select the desired bit using bitwise operations
    assign out = in[offset];

endmodule