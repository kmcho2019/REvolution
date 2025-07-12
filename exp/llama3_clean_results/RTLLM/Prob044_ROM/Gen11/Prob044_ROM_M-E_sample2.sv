module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter INIT_MEM = '{256{16'h0000}}
)(
    input [ADDR_WIDTH-1:0] addr,
    input wr_en,
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

integer i;
initial begin
    for (i = 0; i < MEM_SIZE; i++) begin
        mem[i] = INIT_MEM[i];
    end
end

always @(*) begin
    if (wr_en) begin
        mem[addr] <= din;
    end
end

assign dout = mem[addr];

endmodule