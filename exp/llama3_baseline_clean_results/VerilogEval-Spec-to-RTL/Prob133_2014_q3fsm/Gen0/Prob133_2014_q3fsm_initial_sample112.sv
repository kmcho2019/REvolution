module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B (examining), 2: State B (deciding)
reg [1:0] w_count; // Counts how many times w is 1 in the 3 cycles
reg [1:0] cycle_count; // Counts the current cycle (0 to 2)
reg z_reg; // Register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin // State B (examining)
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 2) begin // End of 3 cycles
                    state <= 2; // Move to deciding state
                end
            end
            2: begin // State B (deciding)
                z_reg <= (w_count == 2); // Set z based on w count
                state <= 1; // Go back to examining
                w_count <= 0;
                cycle_count <= 0;
            end
        endcase
    end
end

assign z = z_reg;

endmodule