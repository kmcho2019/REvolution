module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

// Define the ROM memory with parameterized size
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

// Initial block to pre-load the ROM with specific data
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize the rest of the memory with a default value
    for (int i = 4; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = 16'h0000; // Default value for unused locations
    end
end

// Use assign statement for efficient output
assign dout = mem[addr];

endmodule