module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter ROM_SIZE = 2**ADDR_WIDTH
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:ROM_SIZE-1];

initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    for (int i = 4; i < ROM_SIZE; i++) begin
        mem[i] = 16'h0000; // Initialize the rest with zeros
    end
end

always @(*) begin
    dout = mem[addr];
end

endmodule