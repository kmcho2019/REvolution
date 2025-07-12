module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// ROM-style lookup table
reg [4:0] scancode_rom [0:255]; // 4-bit value + 1-bit valid

integer i;
initial begin
    // Initialize all entries to 0
    for (i = 0; i < 256; i = i + 1)
        scancode_rom[i] = 5'b0;
    
    // Set valid entries
    scancode_rom[8'h45] = 5'b10000; // 0
    scancode_rom[8'h16] = 5'b10001; // 1
    scancode_rom[8'h1e] = 5'b10010; // 2
    scancode_rom[8'h26] = 5'b10011; // 3
    scancode_rom[8'h25] = 5'b10100; // 4
    scancode_rom[8'h2e] = 5'b10101; // 5
    scancode_rom[8'h36] = 5'b10110; // 6
    scancode_rom[8'h3d] = 5'b10111; // 7
    scancode_rom[8'h3e] = 5'b11000; // 8
    scancode_rom[8'h46] = 5'b11001; // 9
end

// Output assignment
assign out = scancode_rom[code][3:0];
assign valid = scancode_rom[code][4];

endmodule