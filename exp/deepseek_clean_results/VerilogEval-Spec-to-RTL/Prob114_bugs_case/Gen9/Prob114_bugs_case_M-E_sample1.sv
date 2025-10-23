module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Define memory array (256 entries x 5 bits)
reg [4:0] scancode_rom [0:255];

initial begin
    // Initialize all entries to 0 (invalid)
    for (integer i = 0; i < 256; i = i + 1)
        scancode_rom[i] = 5'b0_0000;

    // Set valid entries
    scancode_rom[8'h45] = 5'b1_0000; // 0
    scancode_rom[8'h16] = 5'b1_0001; // 1
    scancode_rom[8'h1e] = 5'b1_0010; // 2
    scancode_rom[8'h26] = 5'b1_0011; // 3
    scancode_rom[8'h25] = 5'b1_0100; // 4
    scancode_rom[8'h2e] = 5'b1_0101; // 5
    scancode_rom[8'h36] = 5'b1_0110; // 6
    scancode_rom[8'h3d] = 5'b1_0111; // 7
    scancode_rom[8'h3e] = 5'b1_1000; // 8
    scancode_rom[8'h46] = 5'b1_1001; // 9
end

always @(*) begin
    {valid, out} = scancode_rom[code];
end

endmodule