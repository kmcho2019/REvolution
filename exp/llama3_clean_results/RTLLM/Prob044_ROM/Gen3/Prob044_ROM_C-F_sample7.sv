module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter ROM_SIZE = 2**ADDR_WIDTH
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:ROM_SIZE-1];

integer i;
initial begin
    for (i = 0; i < ROM_SIZE; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        else mem[i] = 16'h0000; // Initialize with zeros
    end
end

always @(*) begin
    // Continuously output the data stored at the address specified by addr
    dout = mem[addr];
end

endmodule