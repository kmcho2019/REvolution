module ROM (
    input clk,                // Clock input
    input oe,                 // Output enable
    input [7:0] addr,         // 8-bit address input
    output reg [15:0] dout    // Registered 16-bit output
);

    // Reduced memory array: 16 locations of 16 bits each
    reg [15:0] mem [0:15];

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations to 0 (optional)
        for (integer i = 4; i < 16; i = i + 1)
            mem[i] = 16'h0000;
    end

    // Synchronous read operation
    always @(posedge clk) begin
        if (oe)
            dout <= mem[addr[3:0]];  // Only use lower 4 bits of address
        else
            dout <= 16'bz;           // High impedance when disabled
    end

endmodule