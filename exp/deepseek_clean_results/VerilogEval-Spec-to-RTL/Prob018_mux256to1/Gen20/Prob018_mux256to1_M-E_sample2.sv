module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Priority encoder to one-hot conversion
    wire [255:0] one_hot_sel;
    assign one_hot_sel = (256'b1 << sel);

    // Crossbar switch implementation
    wire [255:0] selected_bits;
    assign selected_bits = in & one_hot_sel;

    // Final output reduction
    assign out = |selected_bits;

endmodule