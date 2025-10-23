module ROM #(
    parameter DEPTH = 256,            // Configurable memory depth
    parameter WIDTH = 16,            // Configurable data width
    parameter DEFAULT_VAL = 16'h0000 // Default value for uninitialized locations
) (
    input [7:0] addr,
    output [WIDTH-1:0] dout
);

    // Memory array declaration with configurable size
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory with specific values and default
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (int i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = DEFAULT_VAL; // Initialize remaining locations
        end
    end

    // Continuous read with address range check
    assign dout = (addr < DEPTH) ? mem[addr] : DEFAULT_VAL;

endmodule