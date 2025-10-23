module ROM(
    input [7:0] addr,
    output [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Initialize memory locations with fixed data
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed, for this example, the rest will be 0
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
end

always @(*) begin
    // Output the data stored at the specified address
    dout = mem[addr];
end

endmodule