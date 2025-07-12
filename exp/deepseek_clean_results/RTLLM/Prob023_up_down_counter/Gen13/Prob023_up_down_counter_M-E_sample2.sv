module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [3:0] seg_enable;
reg [15:0] next_count;

// Segment enable logic
assign seg_enable[0] = 1'b1; // LSB segment always enabled
assign seg_enable[1] = (up_down) ? (&count[3:0])  : (~|count[3:0]);
assign seg_enable[2] = (up_down) ? (&count[7:4])   : (~|count[7:4]);
assign seg_enable[3] = (up_down) ? (&count[11:8])  : (~|count[11:8]);

// Next count logic
always @(*) begin
    next_count = count;
    
    if (reset) begin
        next_count = 16'h0000;
    end else begin
        // Segment 0 (bits 3:0)
        if (seg_enable[0]) begin
            next_count[3:0] = up_down ? count[3:0] + 1'b1 : count[3:0] - 1'b1;
        end
        
        // Segment 1 (bits 7:4)
        if (seg_enable[1]) begin
            next_count[7:4] = up_down ? count[7:4] + 1'b1 : count[7:4] - 1'b1;
        end
        
        // Segment 2 (bits 11:8)
        if (seg_enable[2]) begin
            next_count[11:8] = up_down ? count[11:8] + 1'b1 : count[11:8] - 1'b1;
        end
        
        // Segment 3 (bits 15:12)
        if (seg_enable[3]) begin
            next_count[15:12] = up_down ? count[15:12] + 1'b1 : count[15:12] - 1'b1;
        end
    end
end

// Register update
always @(posedge clk) begin
    count <= next_count;
end

endmodule