module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rst_n,
    input [ADDR_WIDTH-1:0] addr,
    input en,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initialize memory locations with specific values, other locations default to 0
initial begin
    for (int i = 0; i < MEM_SIZE; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        else mem[i] = 16'h0000;
    end
end

// Use a control signal to enable or disable the ROM access
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout <= 16'h0000;
    end else if (en) begin
        dout <= mem[addr];
    end else begin
        dout <= 16'h0000;
    end
end

endmodule