module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Directly select the bit from 'in' indexed by 'sel'
    assign out = in[sel];

endmodule