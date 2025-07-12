module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Direct indexed selection of the bit specified by sel
    assign out = in[sel];
endmodule