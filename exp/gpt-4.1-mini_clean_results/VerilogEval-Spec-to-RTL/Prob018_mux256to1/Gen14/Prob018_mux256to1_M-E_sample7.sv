module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [255:0] one_hot_sel;

    // One-hot decode the 8-bit sel to 256 bits
    assign one_hot_sel = 1'b1 << sel;

    // Bitwise AND input bits with one-hot selector
    wire [255:0] masked = in & one_hot_sel;

    // OR reduction to produce the selected bit output
    assign out = |masked;

endmodule