module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (00), B (01), and additional states for B's sub-states if needed
reg [1:0] counter; // Counter for 3 clock cycles
reg w_count; // Count occurrences of w=1

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to state B
                end
            end
            2'b01: begin // State B, initial state for w check
                counter <= 2'b01;
                w_count <= w;
                state <= 2'b10; // Move to sub-state of B for counting
            end
            2'b10: begin // State B's sub-state, first cycle
                if (counter == 2'b01) begin
                    counter <= 2'b10;
                    w_count <= w_count + w;
                    state <= 2'b11; // Move to next sub-state
                end
            end
            2'b11: begin // State B's sub-state, second cycle
                if (counter == 2'b10) begin
                    counter <= 2'b11;
                    w_count <= w_count + w;
                    state <= 2'b01; // Back to initial B state to check result
                end
            end
            default: begin
                // Evaluate w_count and set z
                if (w_count == 2) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                w_count <= w; // Reset w_count for next cycle
                counter <= 2'b01; // Reset counter for next cycle
                state <= 2'b10; // Continue checking
            end
        endcase
    end
end

endmodule