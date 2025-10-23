module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] = '{default: 16'd0, 0: 16'hA0A0, 1: 16'hB1B1, 2: 16'hC2C2, 3: 16'hD3D3};

assign dout = mem[addr];

endmodule