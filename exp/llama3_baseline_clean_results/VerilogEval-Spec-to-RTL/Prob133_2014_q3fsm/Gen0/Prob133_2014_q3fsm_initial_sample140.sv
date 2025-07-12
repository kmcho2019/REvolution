module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: 0 - State A, 1 - State B
reg [1:0] count_w; // Counter for w = 1 in state B
reg [2:0] cycle_count; // Counter for 3 cycles in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    count_w <= 0;
                    cycle_count <= 1; // Start cycle count
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment w count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 3) begin // After 3 cycles
                    if (count_w == 2) begin
                        z <= 1; // Set z if w = 1 exactly twice
                    end else begin
                        z <= 0; // Otherwise, clear z
                    end
                    count_w <= 0; // Reset w count
                    cycle_count <= 1; // Reset cycle count
                end
            end
        endcase
    end
end

endmodule