module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the 1024-bit input vector into 16 chunks of 64 bits each
wire [63:0] chunk [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign chunk[i] = in[(i * 64) +: 64];
end

// First level of multiplexing: select one of 16 chunks based on the 4 most significant bits of the selector
wire [63:0] selected_chunk;
assign selected_chunk = chunk[sel[7:4]];

// Second level of multiplexing: select one of 16 4-bit values from the selected chunk based on the 4 least significant bits of the selector
assign out = selected_chunk[(sel[3:0] * 4) +: 4];

endmodule