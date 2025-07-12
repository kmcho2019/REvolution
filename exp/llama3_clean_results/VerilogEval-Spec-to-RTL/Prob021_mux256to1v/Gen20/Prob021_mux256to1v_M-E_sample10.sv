module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Divide the 1024-bit input vector into 64 segments of 16 bits each
wire [15:0] segment [63:0];
genvar i;
for (i = 0; i < 64; i++) begin
    assign segment[i] = in[(i * 16) +: 16];
end

// First stage: select one of 64 possible 16-bit segments
wire [15:0] stage1_out;
assign stage1_out = segment[block_sel];

// Second stage: select one of 4 possible 4-bit segments from the chosen 16-bit segment
wire [3:0] stage2_out;
assign stage2_out = stage1_out[(addr[1:0] * 4) +: 4];

// Third stage: select the final 4-bit output from the chosen 4-bit segment
assign out = stage2_out;

endmodule