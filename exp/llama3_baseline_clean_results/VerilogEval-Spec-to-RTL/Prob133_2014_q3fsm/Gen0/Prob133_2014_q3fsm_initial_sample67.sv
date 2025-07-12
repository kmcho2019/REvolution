module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0) and B (1)
reg [2:0] w_history; // To keep track of last 3 w values
reg [1:0] count_window; // Counter for the 3-clock cycle window
reg w_count; // Count of w=1 in the window
reg next_z; // Next value of z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_history <= 3'b000; // Reset w history
        count_window <= 0; // Reset window counter
        w_count <= 0; // Reset w count
        z <= 0; // Reset z
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to State B
                end
            end
            1: begin // State B
                // Update w history
                w_history <= {w_history[1:0], w};
                
                // Update count_window
                count_window <= count_window + 1;
                
                // If we are at the end of a window
                if (count_window == 2) begin
                    // Count w=1 in the window
                    w_count <= w_history[2] + w_history[1] + w_history[0];
                    
                    // Determine next z
                    if (w_count == 2) begin
                        next_z <= 1;
                    end else begin
                        next_z <= 0;
                    end
                    
                    // Reset for next window
                    count_window <= 0;
                    w_count <= 0;
                end
            end
        endcase
        
        // Update z
        z <= next_z;
    end
end

endmodule