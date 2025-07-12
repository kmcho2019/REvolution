module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the selected bit index directly
    assign out = in[sel];

endmodule