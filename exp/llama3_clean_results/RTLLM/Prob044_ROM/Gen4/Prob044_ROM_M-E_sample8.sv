module Distributed_ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter NUM_SEGMENTS = 16,
    parameter SEGMENT_SIZE = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] segment_mem [0:NUM_SEGMENTS-1][0:SEGMENT_SIZE-1];

initial begin
    // Initialize segment 0
    segment_mem[0][0] = 16'hA0A0;
    segment_mem[0][1] = 16'hB1B1;
    segment_mem[0][2] = 16'hC2C2;
    segment_mem[0][3] = 16'hD3D3;
    // Initialize other segments as needed
end

// Calculate segment and location based on addr
wire [3:0] segment_addr = addr[7:4];
wire [3:0] location_addr = addr[3:0];

// Directly assign dout based on segment and location
assign dout = segment_mem[segment_addr][location_addr];

endmodule