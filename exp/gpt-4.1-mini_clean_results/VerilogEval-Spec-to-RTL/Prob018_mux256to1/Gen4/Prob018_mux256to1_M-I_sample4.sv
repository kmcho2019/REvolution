module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Directly assign the selected bit from input vector using 8-bit selector
    assign out = in[sel];
endmodule