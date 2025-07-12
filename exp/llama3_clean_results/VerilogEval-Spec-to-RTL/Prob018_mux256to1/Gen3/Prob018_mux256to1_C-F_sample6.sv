module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select input
    output out // 1-bit output
);

    // Use a direct indexing approach for simplicity and speed
    assign out = in[sel]; // Assign the selected bit to the output using continuous assignment

endmodule