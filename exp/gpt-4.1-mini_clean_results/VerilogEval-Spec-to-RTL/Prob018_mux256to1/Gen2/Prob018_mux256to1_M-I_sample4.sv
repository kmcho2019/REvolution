module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Directly assign the selected bit from 'in' to 'out' based on 'sel'
    assign out = in[sel];

endmodule