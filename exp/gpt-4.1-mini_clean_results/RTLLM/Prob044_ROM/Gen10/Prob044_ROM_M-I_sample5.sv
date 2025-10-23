module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 1 << ADDR_WIDTH
)(
    input  wire                    clk,
    input  wire [ADDR_WIDTH-1:0]  addr,
    output reg  [DATA_WIDTH-1:0]  dout
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other memory locations can be initialized here as needed
    end

    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule