module ROM(
    input [7:0] addr,
    output [15:0] dout
);

// Define the number of blocks and locations per block
localparam NUM_BLOCKS = 16;
localparam LOCATIONS_PER_BLOCK = 16;

// Define the width of the address bits for block selection and location selection
localparam BLOCK_ADDR_WIDTH = 4;
localparam LOC_ADDR_WIDTH = 4;

// Declare the memory array as a 2D array of blocks
reg [15:0] mem [NUM_BLOCKS-1:0][LOCATIONS_PER_BLOCK-1:0];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0][0] = 16'hA0A0;
    mem[0][1] = 16'hB1B1;
    mem[0][2] = 16'hC2C2;
    mem[0][3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Decoder to select the block based on the higher bits of the address
reg [NUM_BLOCKS-1:0] block_sel;
always @(*) begin
    block_sel = 1'b0;
    block_sel[addr[BLOCK_ADDR_WIDTH+LOC_ADDR_WIDTH-1:LOC_ADDR_WIDTH]] = 1'b1;
end

// Select the location within the chosen block based on the lower bits of the address
reg [15:0] block_out [NUM_BLOCKS-1:0];
always @(*) begin
    for (int i = 0; i < NUM_BLOCKS; i++) begin
        block_out[i] = mem[i][addr[LOC_ADDR_WIDTH-1:0]];
    end
end

// Output the data from the selected block and location
assign dout = block_out[addr[BLOCK_ADDR_WIDTH+LOC_ADDR_WIDTH-1:LOC_ADDR_WIDTH]];

endmodule