module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Direct indexing of the 256-bit vector with 8-bit selector for flat mux
    assign out = in[sel];
endmodule