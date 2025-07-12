module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select input
    output out // 1-bit output
);

    // Directly select the output based on the input select signal
    assign out = in[sel]; // Assign the selected bit to the output using continuous assignment

endmodule