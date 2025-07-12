module Hybrid_ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter NUM_DIST_RAM = 4
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam BLOCK_RAM_ADDR_WIDTH = ADDR_WIDTH - $clog2(NUM_DIST_RAM);
localparam BLOCK_RAM_SIZE = 2**BLOCK_RAM_ADDR_WIDTH;

reg [DATA_WIDTH-1:0] dist_ram [0:NUM_DIST_RAM-1][0:2**($clog2(NUM_DIST_RAM))-1];
reg [DATA_WIDTH-1:0] block_ram [0:BLOCK_RAM_SIZE-1];

initial begin
    // Initialize distributed RAMs with frequently used data
    dist_ram[0][0] = 16'hA0A0;
    dist_ram[0][1] = 16'hB1B1;
    dist_ram[1][0] = 16'hC2C2;
    dist_ram[1][1] = 16'hD3D3;
    // Initialize block RAM with less frequently used data
    for (int i = 0; i < BLOCK_RAM_SIZE; i++) begin
        block_ram[i] = 16'h0000 + i;
    end
end

always @(*) begin
    // Determine which RAM block to access based on the most significant bits of the address
    int ram_block = addr[ADDR_WIDTH-1:$clog2(NUM_DIST_RAM)];
    // Determine the word address within the selected RAM block
    int word_addr = addr[$clog2(NUM_DIST_RAM)-1:0];
    // Access the distributed RAMs for frequently used data
    if (ram_block < NUM_DIST_RAM) begin
        dout = dist_ram[ram_block][word_addr];
    // Access the block RAM for less frequently used data
    end else begin
        dout = block_ram[word_addr];
    end
end

endmodule