module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 0: State A, 1: State B, 2: State Z
reg [1:0] cycle_count; // Counter for the three cycles
reg [1:0] w_count; // Counter for w = 1
reg set_z; // Flag to set output z

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to State A
        cycle_count <= 0;
        w_count <= 0;
        set_z <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to State B
                    cycle_count <= 1; // Initialize cycle_count to 1
                    w_count <= 0; // Reset w_count
                end
            end
            1: begin // State B
                if(w) begin
                    w_count <= w_count + 1; // Increment w_count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle_count
                if(cycle_count == 3) begin
                    set_z <= (w_count == 2)? 1 : 0; // Set flag to set output z
                    cycle_count <= 1; // Reset cycle_count
                    w_count <= 0; // Reset w_count
                    state <= 2; // Transition to State Z
                end
            end
            2: begin // State Z
                z <= set_z; // Set output z
                set_z <= 0; // Reset flag
                state <= 1; // Transition back to State B
            end
        endcase
    end
end

endmodule