module ROM (
    input clk,                // Clock input for synchronous operation
    input oe,                 // Output enable (active high)
    input [3:0] addr,         // Reduced to 4-bit address (16 locations)
    output reg [15:0] dout    // Registered output
);

    // Reduced memory array: 16 locations of 16 bits each
    reg [15:0] mem [0:15];

    // Initialize all memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations to 0
        for (integer i = 4; i < 16; i = i + 1)
            mem[i] = 16'h0000;
    end

    // Synchronous read operation with output enable
    always @(posedge clk) begin
        if (oe)
            dout <= mem[addr];
        else
            dout <= 16'bz;    // High impedance when disabled
    end

endmodule