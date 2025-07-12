module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration: 256 locations of 16-bit data
    reg [15:0] mem [0:255];

    // Initialize memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations remain uninitialized (will be zero in simulation)
    end

    // Continuous read operation using assign
    assign dout = mem[addr];

endmodule