module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Parameterized memory array with initialization
    parameter [15:0] mem [0:255] = '{
        16'hA0A0, 16'hB1B1, 16'hC2C2, 16'hD3D3,
        default: 16'h0000
    };

    // Direct memory lookup
    assign dout = mem[addr];

endmodule