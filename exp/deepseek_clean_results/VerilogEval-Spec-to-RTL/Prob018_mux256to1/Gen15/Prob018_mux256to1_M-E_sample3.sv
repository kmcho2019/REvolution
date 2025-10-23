module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // One-hot decoder using shift operation
    wire [255:0] sel_one_hot = (256'b1 << sel);

    // AND each input with its corresponding one-hot selector
    wire [255:0] and_terms = in & sel_one_hot;

    // OR reduction of all AND terms
    assign out = |and_terms;

endmodule