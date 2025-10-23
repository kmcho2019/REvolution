module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Direct 256-to-1 multiplexer using indexed bit selection
    assign out = in[sel];
endmodule