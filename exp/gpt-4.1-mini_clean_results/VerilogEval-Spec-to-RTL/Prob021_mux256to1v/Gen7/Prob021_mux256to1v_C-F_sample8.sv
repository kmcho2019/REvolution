module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use indexed part-select for efficient 256-to-1 mux selection
    assign out = in[sel*4 +: 4];

endmodule