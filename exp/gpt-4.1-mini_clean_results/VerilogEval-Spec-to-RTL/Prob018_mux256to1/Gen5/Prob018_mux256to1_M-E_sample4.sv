module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly index the input vector with the select signal
    assign out = in[sel];
endmodule