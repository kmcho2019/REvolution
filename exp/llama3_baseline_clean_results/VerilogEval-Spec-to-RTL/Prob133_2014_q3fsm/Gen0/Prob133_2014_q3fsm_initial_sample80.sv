module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 0, State B and its logic = 1
reg [1:0] counter; // Counter for clock cycles in state B
reg w_count; // Count of w = 1 in the three cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 1; // Start counting cycles
                    w_count <= w; // Initialize w_count
                end else begin
                    state <= 0; // Stay in state A
                end
                z <= 0; // z is always 0 in state A
            end
            1: begin // State B and its logic
                if (counter < 3) begin // Still in the 3-cycle window
                    state <= 1; // Stay in this state
                    counter <= counter + 1; // Increment cycle counter
                    w_count <= w_count + w; // Update w_count
                end else begin // End of 3-cycle window
                    state <= 1; // Stay in state B for continuous checking
                    counter <= 1; // Reset cycle counter
                    z <= (w_count == 2) ? 1 : 0; // Set z based on w_count
                    w_count <= w; // Reset and start new count with current w
                end
            end
        endcase
    end
end

endmodule