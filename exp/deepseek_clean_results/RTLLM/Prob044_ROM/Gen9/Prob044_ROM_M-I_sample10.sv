module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialize all memory locations
    integer i;
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;  // Initialize unused locations
        end
    end

    // Direct combinational read operation
    assign dout = mem[addr];

endmodule