module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        integer i;
        // Initialize all memory locations to zero by default
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Initialize specified locations with fixed data
        mem[8'd0] = 16'hA0A0;
        mem[8'd1] = 16'hB1B1;
        mem[8'd2] = 16'hC2C2;
        mem[8'd3] = 16'hD3D3;
    end

    always @(*) begin
        dout = mem[addr];
    end

endmodule