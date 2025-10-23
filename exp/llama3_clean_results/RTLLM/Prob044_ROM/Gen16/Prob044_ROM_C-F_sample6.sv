module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    // Initialize the first four locations with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

always @(*) begin
    // Continuously output the data stored in the ROM at the specified address
    dout = mem[addr];
end

endmodule