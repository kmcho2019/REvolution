// ROM module with distributed memory architecture
module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Define the number of levels in the tree-like structure
localparam NUM_LEVELS = 4;

// Define the size of each memory array at each level
localparam LEVEL_SIZE = 16;

// Declare the memory arrays at each level
reg [DATA_WIDTH-1:0] mem_level1 [0:LEVEL_SIZE-1];
reg [DATA_WIDTH-1:0] mem_level2 [0:LEVEL_SIZE-1];
reg [DATA_WIDTH-1:0] mem_level3 [0:LEVEL_SIZE-1];
reg [DATA_WIDTH-1:0] mem_level4 [0:LEVEL_SIZE-1];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem_level1[0] = 16'hA0A0;
    mem_level1[1] = 16'hB1B1;
    mem_level2[0] = 16'hC2C2;
    mem_level2[1] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Always block to continuously output the data stored at the address specified by addr
always @(*) begin
    // Use the address input to traverse the tree-like structure
    reg [DATA_WIDTH-1:0] temp_data;
    if (addr < LEVEL_SIZE) begin
        temp_data = mem_level1[addr];
    end else if (addr < 2*LEVEL_SIZE) begin
        temp_data = mem_level2[addr-LEVEL_SIZE];
    end else if (addr < 3*LEVEL_SIZE) begin
        temp_data = mem_level3[addr-2*LEVEL_SIZE];
    end else begin
        temp_data = mem_level4[addr-3*LEVEL_SIZE];
    end
    // Assign the output dout to the selected memory location
    dout = temp_data;
end

endmodule