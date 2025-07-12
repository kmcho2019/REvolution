module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Boundary conditions for power optimization
wire seg0_rollover = up_down ? (count[3:0] == 4'hF) : (count[3:0] == 4'h0);
wire seg1_rollover = up_down ? (count[7:4] == 4'hF) : (count[7:4] == 4'h0);
wire seg2_rollover = up_down ? (count[11:8] == 4'hF) : (count[11:8] == 4'h0);

// Full-width next value computation for better timing
wire [15:0] next_count = up_down ? count + 1'b1 : count - 1'b1;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        // Use full-width arithmetic for main operation
        count <= next_count;
        
        // Optional: Power optimization - could be synthesized away if not needed
        /* Alternative implementation with power optimization
        if (up_down) begin
            count[3:0] <= count[3:0] + 1'b1;
            if (seg0_rollover) begin
                count[7:4] <= count[7:4] + 1'b1;
                if (seg1_rollover) begin
                    count[11:8] <= count[11:8] + 1'b1;
                    if (seg2_rollover) begin
                        count[15:12] <= count[15:12] + 1'b1;
                    end
                end
            end
        end else begin
            count[3:0] <= count[3:0] - 1'b1;
            if (seg0_rollover) begin
                count[7:4] <= count[7:4] - 1'b1;
                if (seg1_rollover) begin
                    count[11:8] <= count[11:8] - 1'b1;
                    if (seg2_rollover) begin
                        count[15:12] <= count[15:12] - 1'b1;
                    end
                end
            end
        end
        */
    end
end

endmodule