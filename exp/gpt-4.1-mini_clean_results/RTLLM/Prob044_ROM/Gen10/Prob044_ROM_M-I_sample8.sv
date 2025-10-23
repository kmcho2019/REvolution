module ROM (
    input               clk,
    input        [7:0]  addr,
    output reg  [15:0]  dout
);

    reg [15:0] mem [0:255];
    integer i;

    initial begin
        // Initialize all memory to zero first
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Initialize specific entries
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Read memory combinationally
    wire [15:0] mem_data = mem[addr];

    // Register output to reduce glitches and power
    always @(posedge clk) begin
        dout <= mem_data;
    end

endmodule