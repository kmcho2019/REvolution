module ROM #(
    parameter DEPTH = 256,
    parameter WIDTH = 16
) (
    input [$clog2(DEPTH)-1:0] addr,
    output [WIDTH-1:0] dout
);

    // Memory array declaration with parameterized size
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory locations
    initial begin
        // Specific initialization for first 4 locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to 0 for determinism
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

    // Continuous read operation using direct assignment
    assign dout = mem[addr];

endmodule