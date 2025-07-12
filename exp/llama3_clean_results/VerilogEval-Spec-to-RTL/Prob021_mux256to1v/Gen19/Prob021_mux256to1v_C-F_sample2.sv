module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 1024-bit input vector into 256 blocks of 4 bits each
// This is done to simplify the decoding logic and improve performance
wire [3:0] mem_block [255:0];
genvar i;
for (i = 0; i < 256; i++) begin
    assign mem_block[i] = in[(i * 4) +: 4];
end

// Use the 8-bit selector to directly select the correct memory block
// This approach is efficient and minimizes the critical path
assign out = mem_block[sel];

endmodule