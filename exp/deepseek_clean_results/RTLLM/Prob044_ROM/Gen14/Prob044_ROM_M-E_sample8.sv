module ROM (
    input [7:0] addr,
    output reg [15:0] dout,
    output reg out_of_bounds
);

    // Configuration parameters
    parameter NUM_SEGMENTS = 4;
    parameter SEGMENT_SIZE = 64;
    parameter DEFAULT_OUTPUT = 16'h0000;
    
    // Segment enable signals
    wire [NUM_SEGMENTS-1:0] segment_en;
    
    // Memory segments
    reg [15:0] seg0 [0:SEGMENT_SIZE-1];
    reg [15:0] seg1 [0:SEGMENT_SIZE-1];
    reg [15:0] seg2 [0:SEGMENT_SIZE-1];
    reg [15:0] seg3 [0:SEGMENT_SIZE-1];
    
    // Address decoder
    assign segment_en[0] = (addr[7:6] == 2'b00);
    assign segment_en[1] = (addr[7:6] == 2'b01);
    assign segment_en[2] = (addr[7:6] == 2'b10);
    assign segment_en[3] = (addr[7:6] == 2'b11);
    
    // Initialize segments (only first segment initialized in this example)
    initial begin
        // Initialize segment 0
        seg0[0] = 16'hA0A0;
        seg0[1] = 16'hB1B1;
        seg0[2] = 16'hC2C2;
        seg0[3] = 16'hD3D3;
        
        // Other segments remain uninitialized (will return DEFAULT_OUTPUT)
    end
    
    // Output logic with power gating effect
    always @(*) begin
        out_of_bounds = 1'b0;
        
        case (1'b1)
            segment_en[0]: dout = seg0[addr[5:0]];
            segment_en[1]: dout = seg1[addr[5:0]];
            segment_en[2]: dout = seg2[addr[5:0]];
            segment_en[3]: dout = seg3[addr[5:0]];
            default: begin
                dout = DEFAULT_OUTPUT;
                out_of_bounds = 1'b1;
            end
        endcase
        
        // For simulation: Model power gating effect
        // In real implementation, this would be handled by power gating cells
        if (!segment_en[0]) seg0[addr[5:0]] = 16'bz;
        if (!segment_en[1]) seg1[addr[5:0]] = 16'bz;
        if (!segment_en[2]) seg2[addr[5:0]] = 16'bz;
        if (!segment_en[3]) seg3[addr[5:0]] = 16'bz;
    end

endmodule