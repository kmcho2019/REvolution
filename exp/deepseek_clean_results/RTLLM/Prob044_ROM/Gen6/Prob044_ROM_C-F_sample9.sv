module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input [ADDR_WIDTH-1:0] addr,
    input enable,  // Optional enable for power optimization
    output [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations will be undefined (x in simulation)
    end

    // Gated read operation for power optimization
    assign dout = enable ? mem[addr] : {DATA_WIDTH{1'bz}};

endmodule