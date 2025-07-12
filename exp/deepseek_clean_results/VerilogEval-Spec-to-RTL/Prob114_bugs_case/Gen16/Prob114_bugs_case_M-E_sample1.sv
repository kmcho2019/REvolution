module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Combined ROM storing both out and valid bits
reg [4:0] rom [0:255]; // [4] = valid, [3:0] = out

// Initialize ROM
integer i;
initial begin
    // Default all locations to 0
    for (i = 0; i < 256; i = i + 1) begin
        rom[i] = 5'b0;
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

// Output assignments
assign {valid, out} = rom[code];

endmodule