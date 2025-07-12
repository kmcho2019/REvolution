module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    // Direct combinational indexed selection for 256-to-1 mux
    assign out = in[sel];
endmodule