module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] cycle_cnt; // Counter for the three cycles in State B
reg w_cnt; // Counter for w = 1 in the three cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        cycle_cnt <= 0;
        w_cnt <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to State B when s = 1
                    cycle_cnt <= 1; // Start the cycle counter
                    w_cnt <= w; // Initialize w_cnt based on the current w
                    z <= 0; // Ensure z is 0 during transition
                end else begin
                    state <= 0; // Stay in State A
                    z <= 0; // z remains 0 in State A
                end
            end
            1: begin // State B
                cycle_cnt <= cycle_cnt + 1; // Increment cycle counter
                if (w) begin
                    w_cnt <= w_cnt + 1; // Increment w_cnt if w = 1
                end
                if (cycle_cnt == 3) begin // After three cycles
                    if (w_cnt == 2) begin // If w was 1 exactly twice
                        z <= 1; // Set z to 1
                    end else begin
                        z <= 0; // Otherwise, set z to 0
                    end
                    cycle_cnt <= 1; // Reset cycle counter for next check
                    w_cnt <= w; // Reset w_cnt based on current w
                end
            end
        endcase
    end
end

endmodule