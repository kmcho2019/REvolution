module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal segmented counters
reg [3:0] seg [0:3];
wire [3:0] seg_next [0:3];
wire [3:0] seg_carry;

// Next value and carry generation for each segment
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : SEGMENTS
        // Carry in from previous segment (0 for first segment)
        wire carry_in = (i == 0) ? 1'b1 : seg_carry[i-1];
        
        // Next value computation
        assign seg_next[i] = up_down ? 
                           (carry_in ? seg[i] + 1'b1 : seg[i]) :
                           (carry_in ? seg[i] - 1'b1 : seg[i]);
        
        // Carry out generation
        assign seg_carry[i] = up_down ? 
                            (carry_in & (&seg[i])) : 
                            (carry_in & (seg[i] == 4'b0));
    end
endgenerate

// Synchronous update
always @(posedge clk) begin
    if (reset) begin
        seg[0] <= 4'b0;
        seg[1] <= 4'b0;
        seg[2] <= 4'b0;
        seg[3] <= 4'b0;
    end else begin
        seg[0] <= seg_next[0];
        seg[1] <= seg_next[1];
        seg[2] <= seg_next[2];
        seg[3] <= seg_next[3];
    end
    
    // Synchronous output register
    count <= {seg[3], seg[2], seg[1], seg[0]};
end

endmodule