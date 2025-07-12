module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// First stage: Select one of 16 groups of 64 bits
wire [63:0] group_out;
assign group_out = in[(sel[7:4] * 64) +: 64];

// Second stage: Select one of 16 possible 4-bit inputs from the chosen group
assign out = group_out[(sel[3:0] * 4) +: 4];

endmodule