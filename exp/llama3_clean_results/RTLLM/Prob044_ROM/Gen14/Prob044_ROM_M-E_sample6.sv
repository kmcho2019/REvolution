module HBROM #(
    parameter BLOCK_SIZE = 16, // Number of words in each block
    parameter NUM_BLOCKS = 16, // Number of blocks in the ROM
    parameter ADDR_WIDTH = 8,  // Total address width
    parameter DATA_WIDTH = 16  // Data width of each word
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Calculate the address width for each block
localparam BLOCK_ADDR_WIDTH = $clog2(BLOCK_SIZE);

// Memory array for each block
reg [DATA_WIDTH-1:0] mem [0:NUM_BLOCKS-1][0:BLOCK_SIZE-1];

// Initial block to preload the memory
initial begin
    for (int i = 0; i < NUM_BLOCKS; i++) begin
        for (int j = 0; j < BLOCK_SIZE; j++) begin
            // Example initialization pattern
            mem[i][j] = {16{(i * BLOCK_SIZE + j)%2}};
        end
    end
end

// Always block to handle read operations
always @(*) begin
    // Extract block address and word address from the input address
    reg [NUM_BLOCKS-1:0] block_addr;
    reg [BLOCK_ADDR_WIDTH-1:0] word_addr;
    
    // Calculate block and word addresses
    block_addr = addr[ADDR_WIDTH-1:$clog2(NUM_BLOCKS)];
    word_addr = addr[$clog2(NUM_BLOCKS)-1:0];
    
    // Output the data from the selected block and word address
    dout = mem[block_addr][word_addr];
end

endmodule