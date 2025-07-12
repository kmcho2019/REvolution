module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01)
reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for cycles since entering State B

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to State A
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Transition to State B
                    cycle_count <= 2'b01; // Initialize cycle count
                    w_count <= 2'b00; // Initialize w count
                end
            end
            2'b01: begin // State B
                if (cycle_count < 3) begin // First three cycles in State B
                    cycle_count <= cycle_count + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end else begin // After three cycles, evaluate w_count
                    if (w_count == 2) begin // Exactly two w = 1 occurrences
                        z <= 1'b1; // Set z = 1 in the next cycle
                    end else begin
                        z <= 1'b0; // Otherwise, z = 0
                    end
                    state <= 2'b01; // Stay in State B
                    cycle_count <= 1; // Reset cycle count for next evaluation
                    w_count <= 2'b00; // Reset w count
                end
            end
        endcase
    end
end

endmodule