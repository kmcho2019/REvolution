module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

initial begin
    // Initialize only necessary locations to minimize area and power
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Default other locations to zero, minimizing switching activity
    for (int i = 4; i < MEM_SIZE; i++) begin
        mem[i] = 16'h0000; // Default value, can be changed
    end
end

// Maintain direct assignment for simplicity and potential timing improvement
assign dout = mem[addr];

endmodule