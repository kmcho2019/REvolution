module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// ROM definition for arrow key mappings
reg [3:0] arrow_rom [0:65535]; // 64K x 4-bit ROM

// Initialize ROM contents
integer i;
initial begin
    // Default all entries to 0
    for (i = 0; i < 65536; i = i + 1)
        arrow_rom[i] = 4'b0000;
    
    // Set mappings for arrow keys
    arrow_rom[16'he06b] = 4'b1000; // left
    arrow_rom[16'he072] = 4'b0100; // down
    arrow_rom[16'he074] = 4'b0010; // right
    arrow_rom[16'he075] = 4'b0001; // up
end

// ROM output
wire [3:0] arrow_keys;
assign arrow_keys = arrow_rom[scancode];

// Assign outputs
assign left  = arrow_keys[3];
assign down  = arrow_keys[2];
assign right = arrow_keys[1];
assign up    = arrow_keys[0];

endmodule