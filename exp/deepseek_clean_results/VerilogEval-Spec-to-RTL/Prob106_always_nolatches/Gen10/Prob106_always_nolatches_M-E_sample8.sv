module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // 64Kx4 ROM (optimized by synthesis to only use 4 entries)
    reg [3:0] key_rom [0:65535];
    
    // Initialize ROM contents
    initial begin
        // Default all outputs to 0
        for (integer i = 0; i < 65536; i = i + 1)
            key_rom[i] = 4'b0000;
        
        // Set specific mappings
        key_rom[16'he06b] = 4'b1000; // left
        key_rom[16'he072] = 4'b0100; // down
        key_rom[16'he074] = 4'b0010; // right
        key_rom[16'he075] = 4'b0001; // up
    end

    // Output assignment
    assign {left, down, right, up} = key_rom[scancode];

endmodule