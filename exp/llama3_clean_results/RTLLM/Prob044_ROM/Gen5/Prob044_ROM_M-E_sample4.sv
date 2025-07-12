module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter ROM_DATA = {
        16'hA0A0, 16'hB1B1, 16'hC2C2, 16'hD3D3
    }
) (
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];

integer i;
initial begin
    for (i = 0; i < ROM_DATA.num; i++) begin
        mem[i] = ROM_DATA[i];
    end
end

always @(*) begin
    case (addr)
        8'd0: dout = mem[0];
        8'd1: dout = mem[1];
        8'd2: dout = mem[2];
        8'd3: dout = mem[3];
        default: dout = 16'd0; // Default value for unused addresses
    endcase
end

endmodule