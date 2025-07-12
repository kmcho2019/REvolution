module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [63:0] group_out;

    // First level of multiplexers: select one of the 16 groups of 64 bits
    assign group_out = in[(sel[7:4] * 64) +: 64];

    // Second level of multiplexers: select one of the 16 groups of 4 bits
    assign out = group_out[(sel[3:0] * 4) +: 4];

endmodule