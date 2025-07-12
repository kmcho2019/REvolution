module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B, others for tracking cycles in B
reg [1:0] w_count; // Count of w=1 in last three cycles
reg [1:0] cycle_count; // Cycle counter since entering B

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
                    z <= 0;
                end
            end
            1: begin // State B, cycle 1
                if (w) w_count <= w_count + 1;
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    state <= 2; // Move to evaluation state
                end else begin
                    state <= state + 1;
                end
            end
            2: begin // State B, cycle 2
                if (w) w_count <= w_count + 1;
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    state <= 3; // Move to evaluation state
                end else begin
                    state <= state + 1;
                end
            end
            3: begin // State B, cycle 3
                if (w) w_count <= w_count + 1;
                if (w_count == 2) begin
                    z <= 1; // Set z to 1 if w=1 exactly twice
                end else begin
                    z <= 0;
                end
                state <= 1; // Reset cycle counter and start over
                cycle_count <= 1;
                w_count <= 0;
            end
            default: state <= 0;
        endcase
    end
end

endmodule