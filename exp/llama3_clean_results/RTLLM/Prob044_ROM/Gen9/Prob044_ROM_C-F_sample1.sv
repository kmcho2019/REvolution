module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

initial begin
    // Using a loop to initialize memory locations can be more compact
    // and potentially more efficient for larger ROMs.
    for (int i = 0; i < MEM_SIZE; i++) begin
        case (i)
            0: mem[i] = 16'hA0A0;
            1: mem[i] = 16'hB1B1;
            2: mem[i] = 16'hC2C2;
            3: mem[i] = 16'hD3D3;
            // Other locations can be initialized as needed
            default: mem[i] = 16'h0000; // Default value for uninitialized locations
        endcase
    end
end

// Direct assignment for dout based on addr, which is efficient
// and allows the synthesis tool to optimize the path.
always @(*) begin
    dout = mem[addr];
end

endmodule