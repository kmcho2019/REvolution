module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] = '{ 
    16'hA0A0, 
    16'hB1B1, 
    16'hC2C2, 
    16'hD3D3, 
    default: 16'h0000 
};

always @(*) begin
    dout = mem[addr];
end

endmodule