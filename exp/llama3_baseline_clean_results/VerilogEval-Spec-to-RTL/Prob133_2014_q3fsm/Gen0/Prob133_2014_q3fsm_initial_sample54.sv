module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] w_count; // Count of w = 1
reg [1:0] cycle_count; // Count of cycles since entering state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0;
                    cycle_count <= 0;
                end
                z <= 0; // z is 0 in state A
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin // After 3 cycles
                    if (w_count == 2) begin
                        z <= 1; // Set z = 1 if w_count = 2
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    w_count <= 0; // Reset w_count
                    cycle_count <= 0; // Reset cycle_count
                end else begin
                    z <= 0; // z is 0 during the counting process
                end
            end
            default: begin
                state <= 0; // Default to state A
                w_count <= 0;
                cycle_count <= 0;
                z <= 0;
            end
        endcase
    end
end

endmodule