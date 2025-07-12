module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state = 0; // State A = 0, State B = 1, we don't need more states
reg [1:0] counter = 0; // Counter for the three clock cycles in State B
reg w_count = 0; // Counter for w = 1 in the three cycles

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset to State A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin // Transition to State B if s = 1
                    state <= 1;
                    counter <= 1; // Start the counter for State B
                    w_count <= w ? 1 : 0; // Initialize w_count based on w
                end
            end
            1: begin // State B
                if (counter < 3) begin // Still within the three clock cycles
                    counter <= counter + 1;
                    if (w) begin // Increment w_count if w = 1
                        w_count <= w_count + 1;
                    end
                end else begin // End of three clock cycles
                    z <= (w_count == 2) ? 1 : 0; // Set z based on w_count
                    counter <= 1; // Reset counter for next three cycles
                    w_count <= w ? 1 : 0; // Reset w_count
                end
            end
        endcase
    end
end

endmodule