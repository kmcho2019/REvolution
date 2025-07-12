module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// ROM implementation using a register array
reg [4:0] rom [0:255]; // 5-bit entries: [4] = valid, [3:0] = digit

// Initialize ROM
integer i;
initial begin
    // Default all entries to invalid
    for (i = 0; i < 256; i = i + 1)
        rom[i] = 5'b0;
    
    // Set valid mappings
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

// Output assignment
assign {valid, out} = rom[code];

endmodule