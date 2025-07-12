module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state; // State variable: 0 for state A, 1 for state B
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for cycles in state B
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // State A
                if(s) begin
                    // Transition to state B
                    state <= 1;
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin
                // State B
                if(w) begin
                    // Increment w_count if w = 1
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 2) begin
                    // Update z_reg based on w_count
                    z_reg <= (w_count == 2)? 1 : 0;
                end
                if(cycle_count == 2) begin
                    // Reset cycle_count and w_count
                    cycle_count <= 0;
                    w_count <= 0;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule