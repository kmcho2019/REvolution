module ROM (
    input  wire        clk,    // Clock input for synchronous output register
    input  wire        rst_n,  // Active low synchronous reset
    input  wire [7:0]  addr,   // Address input
    output reg  [15:0] dout    // Registered data output
);

    reg [15:0] mem [0:255];

    integer i;

    initial begin
        // Initialize entire memory to zero
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Initialize specific locations with fixed data
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Synchronous read: output registers the ROM data on rising edge of clk
    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= 16'h0000;
        end else begin
            dout <= mem[addr];
        end
    end

endmodule