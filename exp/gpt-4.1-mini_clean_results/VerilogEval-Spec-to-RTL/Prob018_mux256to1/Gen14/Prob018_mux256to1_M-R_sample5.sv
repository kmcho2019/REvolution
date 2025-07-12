module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly select the bit indexed by sel from input vector
    assign out = in[sel];
endmodule