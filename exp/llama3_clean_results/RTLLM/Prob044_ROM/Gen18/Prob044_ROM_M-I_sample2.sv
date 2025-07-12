module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    // Initialize all locations to a default value to reduce area
    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = 16'h0000; // Default initialization
    end
    // Overwrite specific locations as needed
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

// Continuous assignment is already efficient for performance
assign dout = mem[addr];

endmodule