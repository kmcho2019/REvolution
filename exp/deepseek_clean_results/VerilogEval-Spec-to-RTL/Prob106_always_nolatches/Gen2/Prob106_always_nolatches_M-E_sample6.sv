module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Define ROM contents for scancode to arrow key mapping
    reg [3:0] arrow_rom [0:65535];
    
    // Initialize ROM with default values (all zeros)
    integer i;
    initial begin
        for (i = 0; i < 65536; i = i + 1)
            arrow_rom[i] = 4'b0000;
        
        // Set specific mappings for arrow keys
        arrow_rom[16'he06b] = 4'b1000; // left
        arrow_rom[16'he072] = 4'b0100; // down
        arrow_rom[16'he074] = 4'b0010; // right
        arrow_rom[16'he075] = 4'b0001; // up
    end

    // Output the ROM contents based on scancode input
    wire [3:0] arrow_keys;
    assign arrow_keys = arrow_rom[scancode];
    
    assign left  = arrow_keys[3];
    assign down  = arrow_keys[2];
    assign right = arrow_keys[1];
    assign up    = arrow_keys[0];

endmodule