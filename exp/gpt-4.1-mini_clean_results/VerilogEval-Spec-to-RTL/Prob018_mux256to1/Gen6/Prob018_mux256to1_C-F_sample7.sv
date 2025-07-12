module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Direct indexing: output the bit selected by sel from the input vector.
    assign out = in[sel];

endmodule