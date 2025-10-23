module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Parameter for memory depth (now only 4 locations needed)
    parameter DEPTH = 4;
    
    // Memory array declaration: reduced to only needed locations
    reg [15:0] mem [0:DEPTH-1];

    // Initialize all memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Continuous read operation with address range check
    always @(*) begin
        if (addr < DEPTH) begin
            dout = mem[addr];
        end else begin
            dout = 16'h0000; // Default output for out-of-range addresses
        end
    end

endmodule