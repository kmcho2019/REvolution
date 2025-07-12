module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256,
    parameter SEGMENTS = 4
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

    // Calculate segment size and address width
    localparam SEGMENT_SIZE = DEPTH/SEGMENTS;
    localparam SEG_ADDR_WIDTH = $clog2(SEGMENT_SIZE);
    
    // Segment enable signals
    wire [SEGMENTS-1:0] segment_en;
    wire [SEG_ADDR_WIDTH-1:0] seg_addr = addr[SEG_ADDR_WIDTH-1:0];
    
    // Memory segments
    reg [DATA_WIDTH-1:0] mem [0:SEGMENTS-1][0:SEGMENT_SIZE-1];
    
    // Generate segment enables and initialize memory
    genvar i, j;
    generate
        for (i = 0; i < SEGMENTS; i = i + 1) begin : SEG
            // Segment enable (upper address bits decode)
            assign segment_en[i] = (addr[ADDR_WIDTH-1:SEG_ADDR_WIDTH] == i);
            
            // Initialize each segment
            for (j = 0; j < SEGMENT_SIZE; j = j + 1) begin : INIT
                initial begin
                    // Initialize first 4 locations in each segment
                    if (j < 4) begin
                        case (j)
                            0: mem[i][j] = 16'hA0A0 + (i << 8);
                            1: mem[i][j] = 16'hB1B1 + (i << 8);
                            2: mem[i][j] = 16'hC2C2 + (i << 8);
                            3: mem[i][j] = 16'hD3D3 + (i << 8);
                        endcase
                    end
                    else begin
                        mem[i][j] = 16'h0000;
                    end
                end
            end
        end
    endgenerate
    
    // Multiplexed output - only active segment drives the output
    assign dout = (segment_en[0] ? mem[0][seg_addr] : 16'bz) |
                  (segment_en[1] ? mem[1][seg_addr] : 16'bz) |
                  (segment_en[2] ? mem[2][seg_addr] : 16'bz) |
                  (segment_en[3] ? mem[3][seg_addr] : 16'bz);

endmodule