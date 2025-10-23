module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Directly index into the input vector using the select signal
    assign out <= in[sel];

endmodule