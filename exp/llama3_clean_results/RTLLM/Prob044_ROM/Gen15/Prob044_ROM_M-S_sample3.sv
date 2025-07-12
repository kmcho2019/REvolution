module ROM(
    input [7:0] addr,
    output [15:0] dout
);

// Declare the memory array
reg [15:0] mem [0:255];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Directly assign the output dout to the memory location specified by addr
assign dout = mem[addr];

endmodule