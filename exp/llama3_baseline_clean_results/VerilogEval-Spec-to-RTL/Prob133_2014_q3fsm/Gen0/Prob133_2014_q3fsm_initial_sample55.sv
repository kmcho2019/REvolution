module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B (examine w)
reg [1:0] w_count; // Count of w = 1 in the last 3 cycles
reg [1:0] cycle_count; // Counter for the 3-clock cycle window

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    w_count <= 0;
                    cycle_count <= 0;
                end
                z <= 0; // Ensure z is 0 in State A
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 2) begin // At the end of the 3rd cycle
                    if (w_count == 2) begin // If exactly two w = 1 pulses
                        z <= 1; // Set z = 1 in the next cycle
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    w_count <= 0; // Reset w_count for the next window
                    cycle_count <= 0; // Reset cycle_count
                end else begin
                    z <= 0; // Ensure z is 0 during the counting cycles
                end
            end
            default: state <= 0; // Default to State A
        endcase
    end
end

endmodule