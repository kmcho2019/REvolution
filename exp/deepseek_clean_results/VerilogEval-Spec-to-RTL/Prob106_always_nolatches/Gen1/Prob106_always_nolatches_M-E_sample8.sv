module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // 16-bit address space ROM with 4-bit output
    reg [3:0] arrow_rom [0:65535];
    
    // Initialize ROM contents
    initial begin
        // Default all outputs to 0
        arrow_rom = '{default:4'b0000};
        // Set specific mappings
        arrow_rom[16'he06b] = 4'b1000; // left
        arrow_rom[16'he072] = 4'b0100; // down
        arrow_rom[16'he074] = 4'b0010; // right
        arrow_rom[16'he075] = 4'b0001; // up
    end
    
    // Assign outputs from ROM
    assign {left, down, right, up} = arrow_rom[scancode];

endmodule