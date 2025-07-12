module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the index of the selected bit within the 256-bit input vector
    // and assign the corresponding bit to the output port
    assign out = in[sel];

endmodule