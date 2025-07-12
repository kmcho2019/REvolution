module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state = 0; // State A (0) and State B (1, 2, 3) combined
reg [1:0] w_count = 0; // Count of w pulses in three cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                end
                z <= 0;
            end
            1, 2, 3: begin // State B (three cycles)
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w is high
                end
                if (state == 3) begin // After three cycles
                    if (w_count == 2) begin
                        z <= 1; // Set z if w_count is 2
                    end else begin
                        z <= 0; // Otherwise, z remains 0
                    end
                    state <= 1; // Reset state for next three cycles
                    w_count <= 0; // Reset w_count
                end else begin
                    state <= state + 1; // Increment state (cycle counter)
                end
            end
            default: begin
                state <= 0; // Default to state A
            end
        endcase
    end
end

endmodule