module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Memory array with explicit initialization
    reg [15:0] mem [0:255];

    // Initialize memory - explicit zeros for power optimization
    integer i;
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (i = 4; i < 256; i = i + 1)
            mem[i] = 16'h0000;  // Explicit zero initialization
    end

    // Continuous read operation
    assign dout = mem[addr];

endmodule