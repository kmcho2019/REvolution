module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // Counter for clock cycles in state B
reg [1:0] w_count; // Counter for w = 1 occurrences
reg state; // 0 for state A, 1 for state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        if (state == 0) begin // State A
            if (s == 1) begin
                state <= 1; // Transition to state B
                counter <= 1; // Start counting clock cycles
                w_count <= w; // Initialize w_count based on current w
                z <= 0; // Reset z
            end
        end else begin // State B
            if (counter < 3) begin // Within the three-clock-cycle window
                counter <= counter + 1; // Increment clock cycle counter
                if (w == 1) begin
                    w_count <= w_count + 1; // Increment w occurrence counter if w = 1
                end
            end else begin // End of the three-clock-cycle window
                counter <= 1; // Reset clock cycle counter
                if (w_count == 2) begin // Check if w = 1 exactly twice
                    z <= 1; // Set z = 1 for the next clock cycle
                end else begin
                    z <= 0; // Otherwise, z = 0
                end
                w_count <= w; // Reset w_count based on current w for the next window
            end
        end
    end
end

endmodule