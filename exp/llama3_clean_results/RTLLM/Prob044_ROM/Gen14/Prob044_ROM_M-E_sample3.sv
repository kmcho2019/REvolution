module ParamROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

initial begin
    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = {DATA_WIDTH{1'b0}} + i;
    end
end

always @(*) begin
    dout = mem[addr];
end

endmodule