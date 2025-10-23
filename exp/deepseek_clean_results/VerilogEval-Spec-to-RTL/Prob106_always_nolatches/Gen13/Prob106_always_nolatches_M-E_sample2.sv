module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Define ROM contents
reg [3:0] arrow_rom [0:65535];

// Initialize ROM - all zeros except arrow key positions
integer i;
initial begin
    for (i = 0; i < 65536; i = i + 1)
        arrow_rom[i] = 4'b0000;
    
    arrow_rom[16'he06b] = 4'b1000; // left
    arrow_rom[16'he072] = 4'b0100; // down
    arrow_rom[16'he074] = 4'b0010; // right
    arrow_rom[16'he075] = 4'b0001; // up
end

// ROM lookup
wire [3:0] arrow_bits = arrow_rom[scancode];

// Assign outputs
assign left  = arrow_bits[3];
assign down  = arrow_bits[2];
assign right = arrow_bits[1];
assign up    = arrow_bits[0];

endmodule