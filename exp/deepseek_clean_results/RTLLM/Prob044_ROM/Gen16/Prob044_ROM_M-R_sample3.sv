module ROM (
    input clk,            // Clock input for synchronous operation
    input [7:0] addr,     // 8-bit address input
    output reg [15:0] dout // Registered 16-bit output
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Synchronous read operation
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule