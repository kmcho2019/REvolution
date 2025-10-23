module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (0) and State B (1)
reg [1:0] counter; // Counter for clock cycles
reg w_count; // Counter for w = 1
reg next_z; // Next value of z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        next_z <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 1; // Start counter
                    w_count <= w; // Initialize w_count
                end else begin
                    state <= 0; // Stay in A
                end
                next_z <= 0; // z should be 0 in state A
            end
            1: begin // State B
                if (counter < 3) begin // Still monitoring
                    counter <= counter + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    next_z <= 0; // Don't decide on z yet
                end else begin // Finished monitoring
                    if (w_count == 2) begin
                        next_z <= 1; // Set next_z if w_count is 2
                    end else begin
                        next_z <= 0; // Otherwise, next_z is 0
                    end
                    if (s) begin // This check is not necessary as per original description
                        // But added for completeness, assuming we might need to transition based on s in the future
                        state <= 1; // Stay in B if s = 1
                    end else begin
                        state <= 1; // Stay in B
                    end
                    counter <= 1; // Reset counter for next monitoring period
                    w_count <= w; // Reset w_count
                end
            end
        endcase
        z <= next_z; // Update z
    end
end

endmodule