module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    for (int i = 0; i < 256; i++) begin
        // Initialize memory locations with a specific pattern
        // For simplicity, let's initialize with a value based on the address
        mem[i] = {8'b0, addr};
    end
    // Overwrite the first four locations with specific values as required
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

always @(*) begin
    // Directly output the data from the memory location specified by the address
    dout = mem[addr];
end

endmodule