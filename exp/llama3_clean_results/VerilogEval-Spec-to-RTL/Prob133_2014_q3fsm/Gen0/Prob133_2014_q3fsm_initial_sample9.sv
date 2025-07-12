module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] current_state; // 0: A, 1: B1, 2: B2, 3: B3 (not used, to simplify encoding)
reg [1:0] w_count; // Counter for w = 1 occurrences in a 3-cycle window

always @(posedge clk) begin
    if (reset) begin
        current_state <= 0; // Reset to state A
        w_count <= 0;
        z <= 0;
    end else begin
        case (current_state)
            0: begin // State A
                if (s) begin
                    current_state <= 1; // Move to state B1
                    w_count <= 0;
                end
            end
            1: begin // State B1
                if (w) w_count <= w_count + 1;
                current_state <= 2; // Move to state B2
            end
            2: begin // State B2
                if (w) w_count <= w_count + 1;
                current_state <= 3; // Conceptually move to B3, but we use the same encoding for B3 as for an intermediate step
            end
            3: begin // Conceptual B3, using the same encoding as the last step before wrapping around
                if (w) w_count <= w_count + 1;
                if (w_count == 2) begin // Check if w = 1 exactly twice
                    z <= 1;
                end else begin
                    z <= 0;
                end
                current_state <= 1; // Wrap around to state B1 for the next window
                w_count <= 0; // Reset w_count for the next window
            end
        endcase
    end
end

endmodule