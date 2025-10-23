module ROM #(
    parameter DEPTH = 256,
    parameter WIDTH = 16,
    parameter DEFAULT = 16'h0000
) (
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory - only required locations explicitly set
    initial begin
        mem[0] = 16'hA0A0;  // Location 0
        mem[1] = 16'hB1B1;  // Location 1
        mem[2] = 16'hC2C2;  // Location 2
        mem[3] = 16'hD3D3;  // Location 3
        // All other locations will synthesize to DEFAULT
    end

    // Continuous read operation
    always @(*) begin
        dout = mem[addr];
    end

endmodule