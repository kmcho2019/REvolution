module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Reduced memory array: only 4 locations needed
    reg [15:0] mem [0:3];

    // Initialize memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Continuous read operation with address range check
    always @(*) begin
        dout = (addr < 4) ? mem[addr] : 16'h0000;
    end

endmodule