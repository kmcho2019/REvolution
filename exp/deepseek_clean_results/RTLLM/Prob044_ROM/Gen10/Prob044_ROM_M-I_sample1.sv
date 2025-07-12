module ROM #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8,
    parameter MEM_DEPTH = 256
)(
    input clk,                // Clock for optional output register
    input en,                 // Enable signal
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize all memory contents
    integer i;
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (i = 4; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};  // Initialize remaining locations to 0
        end
    end

    // Combinational read path (always active)
    wire [DATA_WIDTH-1:0] dout_next;
    assign dout_next = mem[addr];

    // Optional registered output (reduces switching activity)
    always @(posedge clk) begin
        if (en) begin
            dout <= dout_next;
        end
    end

    /* Alternative pure combinational version:
    always @(*) begin
        dout = mem[addr];
    end
    */

endmodule