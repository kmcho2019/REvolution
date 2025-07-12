module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 0, State B = 1, CheckState = 2
reg [1:0] w_count; // Counter for 'w' highs in the last 3 cycles
reg [1:0] cycle_count; // Counter for cycles since entering state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    w_count <= 0;
                    cycle_count <= 1;
                end else begin
                    state <= 0; // Stay in state A
                end
                z <= 0; // z is always 0 in state A
            end
            1: begin // State B
                if (cycle_count < 3) begin
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    cycle_count <= cycle_count + 1;
                    state <= 1; // Stay in state B for 3 cycles
                end else begin
                    if (w_count == 2) begin
                        z <= 1; // Set z high if w_count is 2
                    end else begin
                        z <= 0; // Otherwise, set z low
                    end
                    w_count <= 0; // Reset w_count
                    cycle_count <= 1; // Reset cycle_count
                    state <= 1; // Continue in state B
                end
            end
        endcase
    end
end

endmodule