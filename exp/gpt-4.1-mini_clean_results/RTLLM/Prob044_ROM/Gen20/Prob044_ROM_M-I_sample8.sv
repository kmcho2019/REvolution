module ROM (
    input  wire        clk,
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations default to zero
        // Initialize other memory locations to zero explicitly (optional)
        integer i;
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Synchronous read: output updates on clock edge
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule