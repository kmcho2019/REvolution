module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Flat 256-to-1 mux using a direct bit indexing of the input vector
    assign out = in[sel];
endmodule