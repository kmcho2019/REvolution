module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state = 0; // 0 - State A, 1 - State B cycle 1, 2 - State B cycle 2, 3 - State B cycle 3
reg [1:0] count = 0; // Counter for w = 1 occurrences
reg prev_state_B = 0; // Flag to track if we were in state B in the previous cycle

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count <= 0;
        z <= 0;
        prev_state_B <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B cycle 1
                    count <= 0;
                    prev_state_B <= 1;
                end else begin
                    state <= 0;
                    count <= 0;
                    prev_state_B <= 0;
                end
                z <= 0; // z is always 0 in state A
            end
            1: begin // State B cycle 1
                if (w) count <= count + 1;
                state <= 2;
                prev_state_B <= 1;
            end
            2: begin // State B cycle 2
                if (w) count <= count + 1;
                state <= 3;
                prev_state_B <= 1;
            end
            3: begin // State B cycle 3
                if (w) count <= count + 1;
                if (count == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                state <= 1; // Loop back to State B cycle 1
                prev_state_B <= 1;
                count <= 0; // Reset counter for next cycle
            end
            default: state <= 0;
        endcase
    end
end

endmodule