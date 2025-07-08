module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    // Memory declaration: 256 locations, each 16-bit wide
    reg [15:0] mem [0:255];

    // Initialize memory with predefined values
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations can be initialized as needed
    end

    // Continuous read operation: output data at the given address
    always @(*) begin
        dout = mem[addr];
    end

endmodule