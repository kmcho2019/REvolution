module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define a packed memory structure
reg [4:0] key_rom [0:255]; // {valid, out[3:0]}

// Initialize the ROM
integer i;
initial begin
    // Default all entries to invalid (0)
    for (i = 0; i < 256; i = i + 1) begin
        key_rom[i] = 5'b0;
    end
    
    // Set valid key codes
    key_rom[8'h45] = 5'b1_0000; // 0
    key_rom[8'h16] = 5'b1_0001; // 1
    key_rom[8'h1e] = 5'b1_0010; // 2
    key_rom[8'h26] = 5'b1_0011; // 3
    key_rom[8'h25] = 5'b1_0100; // 4
    key_rom[8'h2e] = 5'b1_0101; // 5
    key_rom[8'h36] = 5'b1_0110; // 6
    key_rom[8'h3d] = 5'b1_0111; // 7
    key_rom[8'h3e] = 5'b1_1000; // 8
    key_rom[8'h46] = 5'b1_1001; // 9
end

// Output assignments
assign valid = key_rom[code][4];
assign out = key_rom[code][3:0];

endmodule