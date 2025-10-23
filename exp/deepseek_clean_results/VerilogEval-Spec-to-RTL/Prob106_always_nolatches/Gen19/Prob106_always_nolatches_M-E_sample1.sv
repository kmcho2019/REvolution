module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// ROM definition for scancode to arrow mapping
reg [3:0] arrow_rom [0:65535];  // 64K x 4-bit ROM

// Initialize ROM contents
integer i;
initial begin
    // Default all locations to 0 (no arrows)
    for (i = 0; i < 65536; i = i + 1)
        arrow_rom[i] = 4'b0000;
    
    // Program specific arrow key mappings
    arrow_rom[16'he06b] = 4'b1000; // left
    arrow_rom[16'he072] = 4'b0100; // down
    arrow_rom[16'he074] = 4'b0010; // right
    arrow_rom[16'he075] = 4'b0001; // up
end

// ROM lookup
wire [3:0] arrow_bits = arrow_rom[scancode];

// Output assignment
assign {left, down, right, up} = arrow_bits;

endmodule