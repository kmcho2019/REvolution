module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] = '{256{16'h0000}}; // Initialize all locations to 0

// Directly initialize specific locations
assign mem[0] = 16'hA0A0;
assign mem[1] = 16'hB1B1;
assign mem[2] = 16'hC2C2;
assign mem[3] = 16'hD3D3;

// Use addr to directly index into mem array
assign dout = mem[addr];

endmodule