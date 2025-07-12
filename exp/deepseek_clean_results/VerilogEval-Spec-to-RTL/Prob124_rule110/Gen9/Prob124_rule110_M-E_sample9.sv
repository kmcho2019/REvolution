module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Segment parameters
    localparam SEGMENTS = 64;
    localparam SEG_WIDTH = 8;
    
    // Next state computation
    reg [SEGMENTS-1:0] seg_changed;
    wire [511:0] next_q;
    
    // Rule 110 LUT implemented as a constant array
    wire [7:0] rule110_lut = 8'b01101110; // Indexed by {left,center,right}
    
    // Process each segment
    genvar seg;
    generate
        for (seg = 0; seg < SEGMENTS; seg = seg + 1) begin : segment_processing
            // Segment boundaries
            localparam HI = (seg+1)*SEG_WIDTH - 1;
            localparam LO = seg*SEG_WIDTH;
            
            // Boundary conditions
            wire left_boundary = (seg == SEGMENTS-1) ? 1'b0 : q[LO+SEG_WIDTH];
            wire right_boundary = (seg == 0) ? 1'b0 : q[HI-SEG_WIDTH];
            
            // Compute next state for segment
            wire [SEG_WIDTH-1:0] seg_next;
            
            for (genvar i = 0; i < SEG_WIDTH; i = i + 1) begin : bit_processing
                // Get neighbors with boundary handling
                wire left = (i == SEG_WIDTH-1) ? left_boundary : q[LO+i+1];
                wire center = q[LO+i];
                wire right = (i == 0) ? right_boundary : q[LO+i-1];
                
                // Direct LUT access
                assign seg_next[i] = rule110_lut[{left, center, right}];
            end
            
            // Track if segment will change
            assign next_q[HI:LO] = seg_next;
            always @(*) seg_changed[seg] = (next_q[HI:LO] != q[HI:LO]);
        end
    endgenerate

    // State update with selective segment updates
    integer s;
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (s = 0; s < SEGMENTS; s = s + 1) begin
                if (seg_changed[s]) begin
                    q[(s+1)*SEG_WIDTH-1 : s*SEG_WIDTH] <= 
                        next_q[(s+1)*SEG_WIDTH-1 : s*SEG_WIDTH];
                end
            end
        end
    end

endmodule