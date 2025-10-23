module ROM (
    input clk,              // Clock input
    input rst_n,            // Active-low reset
    input oe,               // Output enable
    input [3:0] addr,       // Reduced to 4-bit address (16 locations)
    output reg [15:0] dout  // Registered output
);

    // Reduced memory array: 16 locations of 16 bits each
    reg [15:0] mem [0:15];

    // Initialize memory with explicit values and zeros
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (int i = 4; i < 16; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Synchronous read operation with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 16'h0000;
        end else if (oe) begin
            dout <= mem[addr];
        end else begin
            dout <= 16'hZZZZ;  // High impedance when disabled
        end
    end

endmodule