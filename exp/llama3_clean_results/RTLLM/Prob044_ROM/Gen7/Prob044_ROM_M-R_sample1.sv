module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

integer i;
initial begin
    for (i = 0; i < MEM_SIZE; i++) begin
        case(i)
            0: mem[i] = 16'hA0A0;
            1: mem[i] = 16'hB1B1;
            2: mem[i] = 16'hC2C2;
            3: mem[i] = 16'hD3D3;
            default: mem[i] = 16'h0000;
        endcase
    end
end

assign dout = mem[addr];

endmodule