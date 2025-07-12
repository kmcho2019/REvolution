module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B (examining w), 2: State B (determining z)
reg [1:0] counter; // Counter for the three clock cycles
reg [1:0] w_count; // Count of w = 1 in the three cycles
reg z_reg; // Register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        counter <= 0;
        w_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    counter <= 1; // Start counter
                    w_count <= 0; // Reset w_count
                end
            end
            1: begin // State B (examining w)
                counter <= counter + 1; // Increment counter
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w = 1
                end
                if (counter == 3) begin // After three cycles
                    state <= 2; // Move to determining z
                end
            end
            2: begin // State B (determining z)
                if (w_count == 2) begin // If w = 1 exactly twice
                    z_reg <= 1; // Set z to 1
                end else begin
                    z_reg <= 0; // Otherwise, set z to 0
                end
                state <= 1; // Return to examining w
                counter <= 1; // Reset counter
                w_count <= 0; // Reset w_count
            end
        endcase
    end
end

assign z = z_reg;

endmodule