module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Directly index the input vector with sel to select one bit.
    assign out = in[sel];
endmodule