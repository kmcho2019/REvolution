module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // Current state (0: waiting for s, 1: examining w)
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles
reg z_reg; // Output z

assign z = z_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    w_count <= 0;
                    cycle_count <= 1; // Initialize cycle_count to 1
                end
            end
            1: begin
                // Examine input w and increment w_count if w = 1
                if(w) begin
                    w_count <= w_count + 1;
                end
                // Increment cycle_count
                cycle_count <= cycle_count + 1;
                // Check if three cycles have passed
                if(cycle_count == 4) begin
                    state <= 0;
                    w_count <= 0;
                    cycle_count <= 0;
                    // Set z based on w_count
                    if(w_count == 2) begin
                        z_reg <= 1;
                    end
                    else begin
                        z_reg <= 0;
                    end
                end
                // If not the last cycle, do not set z
                else begin
                    z_reg <= 0;
                end
            end
        endcase
    end
end

endmodule