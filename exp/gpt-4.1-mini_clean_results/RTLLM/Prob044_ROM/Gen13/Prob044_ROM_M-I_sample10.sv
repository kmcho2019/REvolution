module ROM (
    input           clk,
    input      [7:0] addr,
    output reg [15:0] dout
);

    reg [15:0] mem [0:255];
    integer i;

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining memory locations to zero to avoid unknown states
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    reg [7:0] addr_reg;

    always @(posedge clk) begin
        addr_reg <= addr;
        dout <= mem[addr_reg];
    end

endmodule