module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define ROM width (4-bit digit + 1-bit valid = 5 bits)
localparam ROM_WIDTH = 5;
localparam ROM_DEPTH = 256;

// ROM contents - initialized with {valid, digit}
reg [ROM_WIDTH-1:0] rom [0:ROM_DEPTH-1];

// Initialize ROM - only valid codes are set
integer i;
initial begin
    for (i = 0; i < ROM_DEPTH; i = i + 1) begin
        rom[i] = 5'b0;  // Default to invalid
    end
    
    // Set valid key codes
    rom[8'h45] = 5'b1_0000; // 0
    rom[8'h16] = 5'b1_0001; // 1
    rom[8'h1e] = 5'b1_0010; // 2
    rom[8'h26] = 5'b1_0011; // 3
    rom[8'h25] = 5'b1_0100; // 4
    rom[8'h2e] = 5'b1_0101; // 5
    rom[8'h36] = 5'b1_0110; // 6
    rom[8'h3d] = 5'b1_0111; // 7
    rom[8'h3e] = 5'b1_1000; // 8
    rom[8'h46] = 5'b1_1001; // 9
end

// ROM output
wire [ROM_WIDTH-1:0] rom_out = rom[code];

// Split ROM output into signals
assign out = rom_out[3:0];
assign valid = rom_out[4];

endmodule