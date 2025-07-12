module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter SEGMENT_COUNT = 4,
    parameter SEGMENT_SIZE = 64,
    parameter USE_OUTPUT_REG = 1
)(
    input [ADDR_WIDTH-1:0] addr,
    input enable,
    input clk,  // Only used if output register is enabled
    output [DATA_WIDTH-1:0] dout
);

    // Calculate total memory size and validate parameters
    localparam TOTAL_SIZE = SEGMENT_COUNT * SEGMENT_SIZE;
    
    // Segment memory arrays
    reg [DATA_WIDTH-1:0] segment0 [0:SEGMENT_SIZE-1];
    reg [DATA_WIDTH-1:0] segment1 [0:SEGMENT_SIZE-1];
    reg [DATA_WIDTH-1:0] segment2 [0:SEGMENT_SIZE-1];
    reg [DATA_WIDTH-1:0] segment3 [0:SEGMENT_SIZE-1];
    
    // Output data
    reg [DATA_WIDTH-1:0] data_out;
    reg [DATA_WIDTH-1:0] comb_out;
    
    // Initialize segments with different patterns
    initial begin
        // Segment 0: Linear increment pattern
        for (integer i = 0; i < SEGMENT_SIZE; i = i + 1)
            segment0[i] = i;
            
        // Segment 1: Alternating pattern
        for (integer i = 0; i < SEGMENT_SIZE; i = i + 1)
            segment1[i] = (i % 2) ? 16'hAAAA : 16'h5555;
            
        // Segment 2: Fixed values
        segment2[0] = 16'hA0A0;
        segment2[1] = 16'hB1B1;
        segment2[2] = 16'hC2C2;
        segment2[3] = 16'hD3D3;
        
        // Segment 3: All zeros (default)
    end
    
    // Address decoding and data selection
    always @(*) begin
        if (!enable) begin
            comb_out = {DATA_WIDTH{1'b0}};
        end else if (addr >= TOTAL_SIZE) begin
            comb_out = {DATA_WIDTH{1'b0}};  // Out of range
        end else begin
            case (addr[ADDR_WIDTH-1:ADDR_WIDTH-2])  // Top 2 bits select segment
                2'b00: comb_out = segment0[addr[ADDR_WIDTH-3:0]];
                2'b01: comb_out = segment1[addr[ADDR_WIDTH-3:0]];
                2'b10: comb_out = segment2[addr[ADDR_WIDTH-3:0]];
                2'b11: comb_out = segment3[addr[ADDR_WIDTH-3:0]];
            endcase
        end
    end
    
    // Optional output register
    generate
        if (USE_OUTPUT_REG) begin
            always @(posedge clk) begin
                if (enable)
                    data_out <= comb_out;
                else
                    data_out <= {DATA_WIDTH{1'b0}};
            end
            assign dout = data_out;
        end else begin
            assign dout = comb_out;
        end
    endgenerate

endmodule