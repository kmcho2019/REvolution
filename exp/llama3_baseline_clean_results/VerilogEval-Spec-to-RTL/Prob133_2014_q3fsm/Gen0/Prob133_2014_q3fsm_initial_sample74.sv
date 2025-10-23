module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B, 2 and 3 can be used for sub-states in B if needed
reg [1:0] count_w; // Counts occurrences of w = 1
reg [1:0] cycle_count; // Counts the current cycle within the three-cycle window

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    count_w <= 0;
                    cycle_count <= 1; // Start the three-cycle window
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 3) begin // End of three-cycle window
                    if (count_w == 2) begin
                        z <= 1; // Set z = 1 if w = 1 exactly twice
                    end else begin
                        z <= 0; // Otherwise, set z = 0
                    end
                    count_w <= 0; // Reset count for next window
                    cycle_count <= 1; // Reset cycle count for next window
                end
            end
            default: begin
                state <= 0; // Default back to state A if needed
            end
        endcase
    end
end

endmodule