module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the select signal into two parts: high 4 bits and low 4 bits
wire [3:0] high_sel = sel[7:4];
wire [3:0] low_sel = sel[3:0];

// Create a tree structure to select the desired 4-bit output
wire [255:0] level1_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign level1_out[i] = in[(i * 64) +: 64];
end

wire [15:0] level2_out [15:0];
for (i = 0; i < 16; i++) begin
    assign level2_out[i] = level1_out[i][low_sel * 4 +: 4];
end

assign out = level2_out[high_sel];

endmodule