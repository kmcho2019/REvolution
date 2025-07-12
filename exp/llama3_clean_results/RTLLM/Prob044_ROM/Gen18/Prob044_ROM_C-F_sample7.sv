module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Define the number of blocks and locations per block
localparam NUM_BLOCKS = 16;
localparam LOCATIONS_PER_BLOCK = 16;

// Define the width of the address bits for block selection and location selection
localparam BLOCK_ADDR_WIDTH = 4;
localparam LOC_ADDR_WIDTH = 4;

// Declare the memory array as a 1D array
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

// Decoder to select the block based on the higher bits of the address
always @(*) begin
    dout = mem[addr];
end

endmodule