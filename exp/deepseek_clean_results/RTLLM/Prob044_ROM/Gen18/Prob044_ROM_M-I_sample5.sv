module ROM (
    input clk,              // Clock for output register
    input read_en,          // Read enable signal
    input [7:0] addr,       // 8-bit address input
    output reg [15:0] dout  // 16-bit registered output
);

    // Reduced memory array: 4 locations of 16-bit data
    // (since we only need addresses 0-3)
    reg [15:0] mem [0:3];

    // Initialize all memory contents explicitly
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Internal combinational read
    wire [15:0] mem_out = (addr < 4) ? mem[addr] : 16'h0000;

    // Clocked output register with enable
    always @(posedge clk) begin
        if (read_en) begin
            dout <= mem_out;
        end
    end

    /* Alternative implementation option:
    // For pure combinational output (original behavior)
    always @(*) begin
        dout = (addr < 4) ? mem[addr] : 16'h0000;
    end
    */
endmodule