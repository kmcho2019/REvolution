module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Parameterized initialization values
    parameter [15:0] INIT_VALUES [0:3] = '{
        16'hA0A0,
        16'hB1B1,
        16'hC2C2,
        16'hD3D3
    };

    // Memory read with pattern generation
    always @(*) begin
        if (addr <= 3) begin
            // Direct lookup for initialized addresses
            dout = INIT_VALUES[addr];
        end else begin
            // Pattern generation for other addresses:
            // addr * 0x0101 + 0x1010 creates a predictable pattern
            dout = {8'h0, addr} * 16'h0101 + 16'h1010;
        end
    end

endmodule