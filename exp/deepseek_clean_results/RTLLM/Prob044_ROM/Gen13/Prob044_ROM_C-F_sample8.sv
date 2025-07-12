module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input [ADDR_WIDTH-1:0] addr,
    input oe,  // output enable (active high)
    output [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory with explicit defaults
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {DATA_WIDTH{1'b0}};  // Default to 0
        
        // Custom initialization
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Output with enable control
    assign dout = oe ? mem[addr] : {DATA_WIDTH{1'bz}};

endmodule