module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255] = '{default: 16'h0000, 0: 16'hA0A0, 1: 16'hB1B1, 2: 16'hC2C2, 3: 16'hD3D3};

always @(*) begin
    // Continuously output the data stored at the address specified by addr
    dout = mem[addr];
end

endmodule