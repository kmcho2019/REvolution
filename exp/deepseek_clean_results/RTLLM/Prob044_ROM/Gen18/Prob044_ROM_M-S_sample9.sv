module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Fixed size memory array
    reg [15:0] mem [0:255];

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Direct combinational read
    assign dout = mem[addr];

endmodule