module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Define the number of smaller ROMs
localparam NUM_ROMS = 4;

// Calculate the number of bits for the higher and lower address parts
localparam HIGH_ADDR_BITS = $clog2(NUM_ROMS);
localparam LOW_ADDR_BITS = 8 - HIGH_ADDR_BITS;

// Define the width of each smaller ROM
localparam ROM_WIDTH = 16;

// Define the depth of each smaller ROM
localparam ROM_DEPTH = 2**LOW_ADDR_BITS;

// Declare the smaller ROMs
reg [ROM_WIDTH-1:0] roms [0:NUM_ROMS-1][0:ROM_DEPTH-1];

// Initialize the smaller ROMs
initial begin
    // Initialize the first ROM
    roms[0][0] = 16'hA0A0;
    roms[0][1] = 16'hB1B1;
    
    // Initialize the second ROM
    roms[1][0] = 16'hC2C2;
    roms[1][1] = 16'hD3D3;
    
    // Initialize the remaining ROMs with default values
    for (int i = 2; i < NUM_ROMS; i++) begin
        for (int j = 0; j < ROM_DEPTH; j++) begin
            roms[i][j] = 16'h0000;
        end
    end
end

// Use the higher bits of the address to select the ROM
// and the lower bits to access the data within the ROM
always @(*) begin
    dout = roms[addr[7:HIGH_ADDR_BITS]][addr[LOW_ADDR_BITS-1:0]];
end

endmodule