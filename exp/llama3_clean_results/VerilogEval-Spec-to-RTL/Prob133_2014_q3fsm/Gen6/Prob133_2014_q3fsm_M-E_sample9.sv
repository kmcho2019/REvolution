module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // State A = 0, State B = 1
reg [1:0] cycle_counter; // Counter for clock cycles in state B
reg w_count; // Count of w=1 in the last three clock cycles

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        cycle_counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        if(state == 0) begin // State A
            if(s) begin
                state <= 1; // Transition to state B
                cycle_counter <= 1; // Start counting cycles
                w_count <= w; // Initialize w count
            end
        end else begin // State B
            if(cycle_counter == 3) begin // After three cycles
                if(w_count == 2) begin // If exactly two w=1
                    z <= 1; // Set z to 1
                end else begin
                    z <= 0; // Otherwise, set z to 0
                end
                cycle_counter <= 1; // Reset cycle counter
                w_count <= w; // Reset w count
            end else begin
                cycle_counter <= cycle_counter + 1; // Increment cycle counter
                w_count <= w_count + w; // Increment w count if w=1
            end
        end
    end
end

endmodule