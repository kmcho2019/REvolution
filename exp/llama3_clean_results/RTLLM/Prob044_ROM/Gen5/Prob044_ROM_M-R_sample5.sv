// Refactored version of the ROM module with focus on structural improvements
module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output wire [DATA_WIDTH-1:0] dout
);

// Define the ROM memory array with its contents directly
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1] = {
    16'hA0A0,  // Location 0
    16'hB1B1,  // Location 1
    16'hC2C2,  // Location 2
    16'hD3D3,  // Location 3
    {2**ADDR_WIDTH-4{DATA_WIDTH{1'b0}}}  // Locations 4 to 255 initialized to zero
};

// Use continuous assignment for the output
assign dout = mem[addr];

endmodule