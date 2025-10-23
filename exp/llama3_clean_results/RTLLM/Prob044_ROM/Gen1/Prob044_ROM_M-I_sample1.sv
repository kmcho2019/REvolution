module ROM(
    input [7:0] addr,
    output reg [15:0] dout // Explicitly declare dout as a reg
);

reg [15:0] mem [0:255];

initial begin
    // Initialize all locations with a default value
    for (int i = 0; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
    // Specifically initialize required locations
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

always @(*) begin
    dout = mem[addr];
end

endmodule