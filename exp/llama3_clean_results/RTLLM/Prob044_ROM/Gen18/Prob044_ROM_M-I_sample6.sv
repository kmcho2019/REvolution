// Improved ROM module with parameterized address and data widths
module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Calculate the memory size based on the address width
localparam MEM_SIZE = 2**ADDR_WIDTH;

// Declare the memory array
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
    // For simplicity and potential area reduction, consider initializing the rest of the memory with a default value
    for (int i = 4; i < MEM_SIZE; i++) begin
        mem[i] = 16'h0000; // Initialize with zeros for simplicity
    end
end

// Always block to continuously output the data stored at the address specified by addr
always @(*) begin
    // Directly assign the output dout to the memory location specified by addr
    // This approach is already efficient; consider if any further optimizations are possible based on the specific use case
    dout = mem[addr];
end

endmodule