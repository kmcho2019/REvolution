module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] cycle_count; // Counts the cycles since entering State B
reg w_count; // Counts the number of w=1 in three cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    cycle_count <= 1; // Start counting cycles
                    w_count <= w; // Initialize w_count based on current w
                end
            end
            1: begin // State B
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                if (cycle_count == 3) begin // After three cycles
                    if (w_count == 2) begin // Check if w=1 exactly twice
                        z <= 1; // Set z to 1
                    end else begin
                        z <= 0; // Otherwise, set z to 0
                    end
                    cycle_count <= 1; // Reset cycle count
                    w_count <= w; // Reset w_count based on current w
                end
            end
        endcase
    end
end

endmodule