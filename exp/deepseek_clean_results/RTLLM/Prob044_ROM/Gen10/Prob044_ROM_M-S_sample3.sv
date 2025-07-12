module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array with direct initialization
    reg [15:0] mem [0:255] = '{
        0: 16'hA0A0,
        1: 16'hB1B1,
        2: 16'hC2C2,
        3: 16'hD3D3,
        default: 16'h0000
    };

    // Continuous read operation
    assign dout = mem[addr];

endmodule