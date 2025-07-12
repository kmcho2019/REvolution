module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Initialize the first four memory locations
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    
    // Initialize other locations as needed
    // Example: Initialize all other locations to zero
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
end

always @(*) begin
    // Output the data stored in the ROM at the memory location specified by addr
    dout = mem[addr];
end

endmodule