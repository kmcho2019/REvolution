module ROM #(
    parameter WIDTH = 16,
    parameter DEPTH = 256,
    parameter DEFAULT = 16'h0000
) (
    input clk,
    input en,
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations to default
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = DEFAULT;
        end
    end

    // Registered read operation with enable
    always @(posedge clk) begin
        if (en) begin
            dout <= mem[addr];
        end
    end

endmodule