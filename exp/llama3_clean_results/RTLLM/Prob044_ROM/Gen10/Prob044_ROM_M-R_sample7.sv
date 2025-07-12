module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Initialize memory locations with specific values, other locations default to 0
initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

// Use a case statement within a combinational logic block to assign the output value
always @(*) begin
    case (addr)
        8'd0: dout = mem[0];
        8'd1: dout = mem[1];
        8'd2: dout = mem[2];
        8'd3: dout = mem[3];
        default: dout = mem[addr];
    endcase
end

endmodule