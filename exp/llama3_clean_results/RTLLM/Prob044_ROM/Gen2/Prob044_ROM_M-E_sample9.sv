module ParamROM #(
    parameter MEM_SIZE = 256,  // Memory size (number of locations)
    parameter DATA_WIDTH = 16  // Data width (bits)
) (
    input  wire [7:0] addr,
    output reg  [DATA_WIDTH-1:0] dout
);

// Define the ROM memory array with parameterized size and data width
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initial block to preload the ROM with fixed data
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed
    for (int i = 4; i < MEM_SIZE; i++) begin
        mem[i] = {DATA_WIDTH{1'b0}}; // Default value, can be changed
    end
end

// Always block to output the data stored in the ROM
always @(*) begin
    dout = mem[addr];
end

endmodule