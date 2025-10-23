module SegmentedROM #(
    parameter NUM_SEGMENTS = 4,
    parameter SEGMENT_ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 16
)(
    input [7:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam SEGMENT_SELECTOR_WIDTH = $clog2(NUM_SEGMENTS);

// Divide the address into segment selector and segment address
wire [SEGMENT_SELECTOR_WIDTH-1:0] segment_selector;
wire [SEGMENT_ADDR_WIDTH-1:0] segment_addr;

assign segment_selector = addr[7:6];
assign segment_addr = addr[3:0];

// Initialize each segment
reg [DATA_WIDTH-1:0] segment_mem [0:NUM_SEGMENTS-1][0:2**SEGMENT_ADDR_WIDTH-1];

initial begin
    // Example initialization for each segment
    for (int i = 0; i < NUM_SEGMENTS; i++) begin
        for (int j = 0; j < 2**SEGMENT_ADDR_WIDTH; j++) begin
            // Assign unique values to each location for demonstration
            segment_mem[i][j] = {16{i*j}};
        end
    end
end

// Decoding logic to select the appropriate segment
always @(*) begin
    case (segment_selector)
        2'b00: dout = segment_mem[0][segment_addr];
        2'b01: dout = segment_mem[1][segment_addr];
        2'b10: dout = segment_mem[2][segment_addr];
        2'b11: dout = segment_mem[3][segment_addr];
        default: dout = '0;
    endcase
end

endmodule