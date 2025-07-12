module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Define the memory array with a default initialization value of 0
reg [15:0] mem [0:255] = '{default: 16'h0000};

initial begin
    // Explicitly set the non-zero memory locations
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

always @(*) begin
    // Output the data stored in the ROM at the memory location specified by addr
    dout = mem[addr];
end

endmodule