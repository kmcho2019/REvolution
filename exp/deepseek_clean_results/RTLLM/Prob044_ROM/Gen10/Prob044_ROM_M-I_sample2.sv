module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];

    // Initialization constants
    localparam [15:0] 
        VAL0 = 16'hA0A0,
        VAL1 = 16'hB1B1,
        VAL2 = 16'hC2C2,
        VAL3 = 16'hD3D3;

    // Initialize all memory locations
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;  // Default value
        end
        
        // Set specific values
        mem[0] = VAL0;
        mem[1] = VAL1;
        mem[2] = VAL2;
        mem[3] = VAL3;
    end

    // Direct combinational read
    assign dout = mem[addr];

endmodule