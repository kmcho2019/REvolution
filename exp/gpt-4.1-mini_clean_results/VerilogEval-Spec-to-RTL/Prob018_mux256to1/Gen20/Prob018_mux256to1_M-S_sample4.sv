module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly index the input vector by sel to select the output bit
    assign out = in[sel];
endmodule