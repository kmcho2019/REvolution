module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration as parameter for better optimization
    parameter [15:0] mem [0:255] = '{
        16'hA0A0, 16'hB1B1, 16'hC2C2, 16'hD3D3,
        // Initialize remaining locations to 0
        [4:255] : 16'h0000
    };

    // Continuous read operation using assign
    assign dout = mem[addr];

endmodule