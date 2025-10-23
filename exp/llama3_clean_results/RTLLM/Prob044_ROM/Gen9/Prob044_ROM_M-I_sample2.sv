// ROM module with 8-bit address input and 16-bit output
module ROM(
    input [7:0] addr, // 8-bit address input
    output reg [15:0] dout // 16-bit output
);

// Declare the ROM memory array with 256 locations, each 16 bits wide
reg [15:0] mem [0:255];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize the rest of the memory locations with a default value (e.g., 0)
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
end

// Always block to continuously output the data stored in the ROM at the specified address
always @(*) begin
    // Directly assign the output based on the addr input
    dout = mem[addr];
end

endmodule