module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

    // Parameterized memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Compact initialization
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Default all other locations to 0 (explicit for clarity)
        for (integer i = 4; i < DEPTH; i = i + 1)
            mem[i] = {DATA_WIDTH{1'b0}};
    end

    // Direct combinational read
    assign dout = mem[addr];

endmodule