module ROM(
    input [7:0] addr,
    output [15:0] dout
);

reg [15:0] mem [0:255];

// Initialize memory locations with specific values, other locations default to 0
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

// Directly assign the output value based on the input address
assign dout = mem[addr];

endmodule