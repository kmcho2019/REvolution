module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter BLOCK_SIZE = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam NUM_BLOCKS = 2**ADDR_WIDTH / BLOCK_SIZE;
localparam BLOCK_ADDR_WIDTH = $clog2(BLOCK_SIZE);

reg [DATA_WIDTH-1:0] mem [0:NUM_BLOCKS-1][0:BLOCK_SIZE-1];

initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0][0] = 16'hA0A0;
    mem[0][1] = 16'hB1B1;
    mem[0][2] = 16'hC2C2;
    mem[0][3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

always @(*) begin
    // Calculate block address and location within block
    reg [ADDR_WIDTH-1:0] block_addr;
    reg [BLOCK_ADDR_WIDTH-1:0] loc_addr;
    block_addr = addr / BLOCK_SIZE;
    loc_addr = addr % BLOCK_SIZE;
    
    // Continuously output the data stored at the address specified by addr
    dout = mem[block_addr][loc_addr];
end

endmodule