module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    // Direct indexed selection of the input bit using sel
    assign out = in[sel];
endmodule