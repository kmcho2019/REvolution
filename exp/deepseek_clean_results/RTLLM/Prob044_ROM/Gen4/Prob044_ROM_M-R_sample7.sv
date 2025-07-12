module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialize specific memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Uncomment and add more initialization as needed
        // for (int i = 4; i < 256; i = i + 1) begin
        //     mem[i] = 16'h0000; // Default to 0 if not initialized
        // end
    end

    // Continuous read operation using assign
    assign dout = mem[addr];

endmodule