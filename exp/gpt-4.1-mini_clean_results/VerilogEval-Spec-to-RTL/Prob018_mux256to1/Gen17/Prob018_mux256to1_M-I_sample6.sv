module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly select one bit from the 256-bit input vector using the 8-bit sel index
    assign out = in[sel];
endmodule