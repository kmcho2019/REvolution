module ROM(
    input [7:0] addr,
    output [15:0] dout
);

// Define the number of memory blocks
localparam NUM_BLOCKS = 4;

// Calculate the block size
localparam BLOCK_SIZE = 256 / NUM_BLOCKS;

// Declare the memory blocks
reg [15:0] mem [0:BLOCK_SIZE-1];

// Decoding logic
wire [1:0] block_sel;

// Assign the block selection based on the address
assign block_sel = addr[7:6];

// Memory block outputs
wire [15:0] block_out [0:NUM_BLOCKS-1];

// Initialize each memory block
genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i++) begin
        // Memory block instantiation
        ROM_Block rom_block (
           .addr(addr[5:0]),
           .dout(block_out[i])
        );
    end
endgenerate

// Multiplexing logic
assign dout = block_out[block_sel];

// ROM Block module
module ROM_Block(
    input [5:0] addr,
    output [15:0] dout
);

// Declare the memory array for this block
reg [15:0] mem [0:BLOCK_SIZE-1];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Directly assign the output dout to the memory location specified by addr
assign dout = mem[addr];

endmodule

endmodule