module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for current cycle within the 3-cycle window
reg current_state; // 1 bit to represent states A (0) and B (1)
reg next_state;

always @(posedge clk) begin
    if(reset) begin
        current_state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        current_state <= next_state;
        if(current_state == 0) begin // In state A
            if(s) begin
                next_state <= 1; // Move to state B
                count_w <= 0;
                cycle_count <= 1; // Start counting cycles
            end else begin
                next_state <= 0; // Stay in state A
            end
            z <= 0; // z is always 0 in state A
        end else begin // In state B
            if(cycle_count < 3) begin // Within the 3-cycle window
                next_state <= 1; // Stay in state B
                if(w) begin
                    count_w <= count_w + 1; // Increment count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                z <= 0; // z is 0 during the counting phase
            end else begin // After the 3-cycle window
                next_state <= 1; // Stay in state B for continuous checking
                if(count_w == 2) begin // If w = 1 exactly twice
                    z <= 1; // Set z to 1
                end else begin
                    z <= 0; // Otherwise, set z to 0
                end
                count_w <= 0; // Reset count for next window
                cycle_count <= 1; // Reset cycle count for next window
            end
        end
    end
end

endmodule