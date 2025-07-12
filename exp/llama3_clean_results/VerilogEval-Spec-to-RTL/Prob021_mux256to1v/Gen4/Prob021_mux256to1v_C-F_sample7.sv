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
assign out = group_out[sel[7:4]][(sel[3:0] * 4) +: 4];

endmodule