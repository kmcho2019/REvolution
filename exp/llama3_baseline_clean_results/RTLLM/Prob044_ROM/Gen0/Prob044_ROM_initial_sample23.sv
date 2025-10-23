module ROM(
    input   wire [7:0]  addr,
    output  wire [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
    // Example: mem[4] = 16'hE4E4;
end

always @(*) begin
    // Continuously output the data stored at the memory location specified by addr
    dout = mem[addr];
end

endmodule