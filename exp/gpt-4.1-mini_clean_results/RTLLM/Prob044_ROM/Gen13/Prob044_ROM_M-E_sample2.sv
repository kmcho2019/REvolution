module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    // Memory array: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialize memory contents at elaboration time
    initial begin
        mem[8'd0] = 16'hA0A0;
        mem[8'd1] = 16'hB1B1;
        mem[8'd2] = 16'hC2C2;
        mem[8'd3] = 16'hD3D3;
        // Initialize the rest to zero
        integer i;
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Combinational read output
    always @(*) begin
        dout = mem[addr];
    end

endmodule