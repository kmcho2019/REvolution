module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// First stage: Select one of 16 groups of 64 bits
wire [63:0] group_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign group_out[i] = in[(i * 64) +: 64];
end

// Second stage: Select one of 16 possible 4-bit inputs from the chosen group
wire [3:0] group_sel_out [15:0];
for (i = 0; i < 16; i++) begin
    assign group_sel_out[i] = group_out[i][(sel[3:0] * 4) +: 4];
end

// Final selection based on the 4 most significant bits of the selector
assign out = group_sel_out[sel[7:4]];

endmodule