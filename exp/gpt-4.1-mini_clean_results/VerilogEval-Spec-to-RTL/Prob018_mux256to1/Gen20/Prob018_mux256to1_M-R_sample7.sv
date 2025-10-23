module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly select the bit specified by sel from the 256-bit input vector
    assign out = in[sel];
endmodule