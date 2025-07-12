module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Use a single-stage select logic
    assign out = in[sel];

endmodule