// Tree-ROM module with hierarchical memory structure
module Tree_ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Calculate the number of levels in the tree
localparam NUM_LEVELS = $clog2(2**ADDR_WIDTH);

// Declare the memory blocks
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Always block to continuously output the data stored at the address specified by addr
always @(*) begin
    // Declare the internal address signals
    reg [ADDR_WIDTH-1:0] addr_int;
    reg [DATA_WIDTH-1:0] dout_int;

    // Split the address into smaller segments
    for (int i = 0; i < NUM_LEVELS; i++) begin
        // Calculate the segment width
        reg [ADDR_WIDTH-1:0] segment_width = (ADDR_WIDTH / NUM_LEVELS);

        // Extract the current segment from the address
        reg [ADDR_WIDTH-1:0] segment = addr >> (i * segment_width);

        // Use the segment to select the next block
        addr_int = {addr_int, segment};
    end

    // Assign the output dout to the memory location specified by addr_int
    dout_int = mem[addr_int];
    dout = dout_int;
end

endmodule