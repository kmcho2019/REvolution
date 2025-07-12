module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter MEM_SIZE = 256
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam NUM_BLOCKS = MEM_SIZE / 16;
reg [DATA_WIDTH-1:0] mem [0:NUM_BLOCKS-1][0:15];

initial begin
    for (int i = 0; i < NUM_BLOCKS; i++) begin
        for (int j = 0; j < 16; j++) begin
            mem[i][j] = (i * 16 + j) % 2 ? 16'hA0A0 : 16'hB1B1;
        end
    end
    // Initialize first 4 locations with specific values
    mem[0][0] = 16'hA0A0;
    mem[0][1] = 16'hB1B1;
    mem[0][2] = 16'hC2C2;
    mem[0][3] = 16'hD3D3;
end

always @(*) begin
    dout = mem[addr[ADDR_WIDTH-1:4]][addr[3:0]];
end

endmodule