module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Using a more specific type for the memory array
reg [15:0] mem [256];

initial begin
    // Initialize only the required locations for demonstration
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Default the rest of the memory locations to zero for power savings
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
end

// Continuous assignment for dout
always @(*) begin
    dout = mem[addr];
end

endmodule