module ROM (
    input  wire [7:0] addr,
    output reg  [15:0] dout
);

// Define the ROM memory array
reg [15:0] mem [0:255];

// Initial block to preload the ROM with fixed data
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000; // Default value, can be changed
    end
end

// Always block to output the data stored in the ROM
always @(*) begin
    dout = mem[addr];
end

endmodule