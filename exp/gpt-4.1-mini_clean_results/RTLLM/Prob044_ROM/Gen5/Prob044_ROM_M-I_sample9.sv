module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        integer i;
        // Initialize all locations to zero
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Initialize specific ROM data
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Additional initialization can be added here if needed
    end

    // Continuous assignment for combinational read
    assign dout = mem[addr];

endmodule