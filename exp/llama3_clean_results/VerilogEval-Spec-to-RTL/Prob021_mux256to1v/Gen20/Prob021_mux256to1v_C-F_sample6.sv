module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Use the 8-bit selector to directly select the correct 4-bit output
wire [3:0] mem_block [255:0];
genvar i;
for (i = 0; i < 256; i++) begin
    assign mem_block[i] = in[(i * 4) +: 4];
end

assign out = mem_block[sel];

endmodule