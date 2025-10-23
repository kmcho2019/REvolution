module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Directly use the select signal bits
    assign out = in[sel];

endmodule