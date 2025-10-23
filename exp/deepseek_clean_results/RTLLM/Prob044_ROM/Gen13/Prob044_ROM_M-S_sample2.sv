module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Memory array declaration (256x16)
    reg [15:0] mem [0:255];

    // Initialize memory with specific values
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Direct combinational read path
    assign dout = mem[addr];

endmodule