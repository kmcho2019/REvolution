module ROM (
    input clk,              // Clock for output register
    input read_en,          // Read enable signal
    input [7:0] addr,       // 8-bit address input
    output reg [15:0] dout  // Registered 16-bit output
);

    // Reduced memory array: only 4 locations needed (0-3)
    reg [15:0] mem [0:3];

    // Initialize memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Registered read operation
    always @(posedge clk) begin
        if (read_en) begin
            // Only update output when read_en is active
            // Address is masked to 2 bits since we only have 4 locations
            dout <= mem[addr[1:0]];
        end
    end

endmodule