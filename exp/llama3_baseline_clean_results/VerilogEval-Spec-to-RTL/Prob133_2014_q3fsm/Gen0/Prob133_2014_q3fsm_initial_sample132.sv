module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register, 2 states: A (0) and B (1, 2, 3)
reg [1:0] count; // Counter for counting w = 1 over 3 cycles
reg start_count; // Flag to indicate start of counting

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state
        count <= 0;
        start_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B (counting starts)
                    count <= 0;
                    start_count <= 1; // Set flag to start counting
                end
            end
            1, 2, 3: begin // State B (counting phase)
                if (start_count) begin
                    count <= (w ? 1 : 0); // Initialize count for the first cycle
                    start_count <= 0; // Reset flag
                end else begin
                    count <= count + (w ? 1 : 0); // Increment count if w = 1
                end
                if (state == 3) begin // Last cycle of counting
                    if (count == 2) begin
                        z <= 1; // Set z to 1 if count is exactly 2
                    end else begin
                        z <= 0; // Otherwise, set z to 0
                    end
                    state <= 1; // Reset state to start new counting period
                    count <= 0;
                    start_count <= 1; // Set flag to start new count
                end else begin
                    state <= state + 1; // Move to next cycle
                end
            end
        endcase
    end
end

endmodule