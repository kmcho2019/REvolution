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
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
    for (int i = 4; i < MEM_SIZE; i++) begin
        mem[i] = 16'h0000; // Default value for uninitialized locations
    end
end

// Using assign for direct implementation
assign dout = (addr == 8'd0) ? 16'hA0A0 :
              (addr == 8'd1) ? 16'hB1B1 :
              (addr == 8'd2) ? 16'hC2C2 :
              (addr == 8'd3) ? 16'hD3D3 :
              16'h0000; // Default value for other addresses

endmodule