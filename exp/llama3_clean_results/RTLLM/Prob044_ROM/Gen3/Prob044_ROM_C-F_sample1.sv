module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Define the ROM memory array
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

// Initial block to preload the ROM with fixed data
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed
    for (int i = 4; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = {DATA_WIDTH{1'b0}}; // Default value, can be changed
    end
end

// Always block to output the data stored in the ROM
always @(*) begin
    dout = mem[addr];
end

endmodule