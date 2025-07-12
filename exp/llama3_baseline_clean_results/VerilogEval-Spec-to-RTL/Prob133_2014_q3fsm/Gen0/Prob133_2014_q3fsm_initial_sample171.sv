module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] cycle_counter; // Counter for the three clock cycles
reg w_counter; // Counter for how many times w = 1 in three cycles
reg z_next; // Next value of z

always @(*) begin
    case(state)
        0: begin // State A
            if (s) begin
                state = 1; // Move to State B
                cycle_counter = 0; // Reset cycle counter
                w_counter = 0; // Reset w counter
            end else begin
                state = 0; // Stay in State A
            end
            z_next = 0; // z is always 0 in State A
        end
        1: begin // State B
            if (cycle_counter < 2) begin
                cycle_counter = cycle_counter + 1; // Increment cycle counter
                if (w) begin
                    w_counter = w_counter + 1; // Increment w counter if w = 1
                end
                state = 1; // Stay in State B
            end else begin // Last cycle
                if (w) begin
                    w_counter = w_counter + 1; // Increment w counter if w = 1
                end
                // Evaluate w_counter to set z_next
                if (w_counter == 2) begin
                    z_next = 1; // Set z to 1 if w was 1 exactly twice
                end else begin
                    z_next = 0; // Otherwise, set z to 0
                end
                // Reset counters for the next evaluation
                cycle_counter = 0;
                w_counter = 0;
                state = 1; // Stay in State B
            end
        end
        default: state = 0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state = 0; // Reset state to A
        cycle_counter = 0; // Reset cycle counter
        w_counter = 0; // Reset w counter
        z = 0; // Reset z
    end else begin
        z = z_next; // Update z
    end
end

endmodule