// Simplified ROM module with parameterized address and data widths
module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Memory array declaration
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

// Initial block for pre-loading the ROM with fixed data
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

// Always block for continuous output
always @(*) begin
    dout = mem[addr];
end

endmodule