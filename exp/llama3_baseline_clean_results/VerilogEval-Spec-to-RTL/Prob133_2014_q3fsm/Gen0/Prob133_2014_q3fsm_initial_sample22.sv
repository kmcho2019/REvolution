module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable (0 - A, 1 - B)
reg [1:0] counter; // Counter for clock cycles
reg w_count; // Counter for occurrences of w = 1

always @(posedge clk) begin
    if (reset) begin // Reset condition
        state <= 0; // Reset state to A
        counter <= 0; // Reset counter
        w_count <= 0; // Reset w count
        z <= 0; // Reset output z
    end else begin
        case (state)
            0: begin // State A
                if (s) begin // Transition to state B when s = 1
                    state <= 1;
                    counter <= 1; // Initialize counter to 1 for the first clock cycle in state B
                    w_count <= w; // Initialize w count based on the current value of w
                end
            end
            1: begin // State B
                counter <= counter + 1; // Increment clock cycle counter
                if (w) begin // Increment w count if w = 1
                    w_count <= w_count + 1;
                end
                if (counter == 3) begin // After three clock cycles
                    if (w_count == 2) begin // Check if w was 1 exactly twice
                        z <= 1; // Set output z to 1
                    end else begin
                        z <= 0; // Otherwise, set output z to 0
                    end
                    counter <= 1; // Reset counter for the next set of three clock cycles
                    w_count <= w; // Reset w count based on the current value of w
                end
            end
        endcase
    end
end

endmodule