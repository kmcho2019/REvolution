module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

    // Memory array declaration with configurable parameters
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory contents (explicit zeros for unused locations)
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations to zero
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Continuous read operation - most efficient implementation
    assign dout = mem[addr];

endmodule