module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initialize memory using a loop
initial begin
    for (int i = 0; i < MEM_SIZE; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        // Other locations can be initialized as needed
        else mem[i] = 16'h0000;
    end
end

// Pipelined architecture with lookup table-based memory access
reg [ADDR_WIDTH-1:0] addr_reg;
always @(posedge clk) begin
    addr_reg <= addr;
end

always @(posedge clk) begin
    case (addr_reg)
        8'h0: dout <= 16'hA0A0;
        8'h1: dout <= 16'hB1B1;
        8'h2: dout <= 16'hC2C2;
        8'h3: dout <= 16'hD3D3;
        default: dout <= 16'h0000;
    endcase
end

endmodule