module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Pre-load the ROM with fixed data
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
    // For example, initialize all other locations with a default value
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000; // Initialize with zeros
    end
end

always @(*) begin
    // Continuously output the data stored in the ROM at the location specified by addr
    dout = mem[addr];
end

endmodule