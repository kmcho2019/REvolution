// Define the ROM module with parameterization for flexibility
module ROM #(
    parameter ADDR_WIDTH = 8, // Default address width
    parameter DATA_WIDTH = 16 // Default data width
)(
    input [ADDR_WIDTH-1:0] addr, // Address input
    output [DATA_WIDTH-1:0] dout // Data output
);

// Calculate the memory size based on the address width
localparam MEM_SIZE = 2**ADDR_WIDTH;

// Declare the memory array
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initial block to initialize the memory with specific values
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed, defaulting to zero for demonstration
    for (int i = 4; i < MEM_SIZE; i++) begin
        mem[i] = {DATA_WIDTH{1'b0}}; // Default value, can be changed
    end
end

// Directly assign dout based on addr for simplicity and potential timing improvement
assign dout = mem[addr];

endmodule