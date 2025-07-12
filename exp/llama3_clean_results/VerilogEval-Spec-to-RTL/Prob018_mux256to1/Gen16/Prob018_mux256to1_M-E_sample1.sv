module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Shift the input vector by the number of bits specified by the select signal
    wire [255:0] shifted_in;
    assign shifted_in = in >> sel;

    // Select the least significant bit as the output
    assign out = shifted_in[0];

endmodule