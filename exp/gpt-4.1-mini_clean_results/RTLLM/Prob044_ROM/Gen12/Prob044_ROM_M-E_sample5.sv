module ROM (
    input  wire        clk,
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    // Memory array declaration: 256 x 16-bit ROM
    reg [15:0] mem [0:255];

    initial begin
        // Initialize specific memory locations with fixed data
        mem[8'd0] = 16'hA0A0;
        mem[8'd1] = 16'hB1B1;
        mem[8'd2] = 16'hC2C2;
        mem[8'd3] = 16'hD3D3;

        // Initialize other memory locations to zero
        integer i;
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Synchronous read: output data registered on clock's rising edge
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule