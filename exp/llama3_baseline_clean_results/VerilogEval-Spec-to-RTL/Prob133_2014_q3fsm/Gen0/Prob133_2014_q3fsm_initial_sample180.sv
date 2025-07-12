module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (0) and State B (1,2,3) combined into two bits for simplicity
reg [1:0] w_count; // Counter for w = 1 within a 3-cycle window
reg [1:0] cycle_count; // Counter for the current cycle within the 3-cycle window

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    cycle_count <= 1; // Start counting cycles
                    w_count <= w ? 1 : 0; // Initialize w_count based on current w
                end else begin
                    state <= 0; // Stay in state A
                end
                z <= 0; // z is always 0 in state A
            end
            1, 2, 3: begin // State B
                if (cycle_count < 3) begin // Still within the 3-cycle window
                    state <= state + 1; // Move to the next cycle
                    cycle_count <= cycle_count + 1;
                    if (w) begin
                        w_count <= w_count + 1; // Increment w_count if w = 1
                    end
                end else begin // End of the 3-cycle window
                    if (w_count == 2) begin // If w was 1 exactly twice, set z = 1
                        z <= 1;
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    state <= 1; // Reset state to the start of state B
                    cycle_count <= 1; // Reset cycle counter
                    w_count <= w ? 1 : 0; // Reset w_count based on current w
                end
            end
        endcase
    end
end

endmodule