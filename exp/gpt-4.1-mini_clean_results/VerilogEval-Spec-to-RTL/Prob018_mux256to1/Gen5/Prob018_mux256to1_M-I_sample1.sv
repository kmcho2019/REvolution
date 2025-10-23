module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Direct indexed selection: the synthesis tool will infer an optimized 256-to-1 mux.
    assign out = in[sel];
endmodule