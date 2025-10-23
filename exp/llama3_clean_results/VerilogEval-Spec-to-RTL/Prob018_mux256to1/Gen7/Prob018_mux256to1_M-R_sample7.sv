module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the index of the bit to be selected
    wire [7:0] idx = sel;

    // Select the correct bit from the input vector
    assign out = in[idx];

endmodule