module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // One-hot decoder
    wire [255:0] one_hot;
    assign one_hot = (256'b1 << sel);

    // Crossbar switch implementation
    wire [255:0] and_results;
    assign and_results = in & one_hot;

    // OR reduction
    assign out = |and_results;

endmodule