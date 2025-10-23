module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Current state (0: A, 1: B, 2: C, 3: D)
reg [2:0] count_w; // Count of w in three cycles
reg [1:0] cycle; // Cycle counter
reg z_reg; // Register to hold z value

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state to A
        count_w <= 0; // Reset count of w
        cycle <= 0; // Reset cycle counter
        z_reg <= 0; // Reset z
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    count_w <= 0; // Reset count of w
                    cycle <= 1; // Reset cycle counter
                end
            end
            1: begin // State B
                if(w) begin
                    count_w <= count_w + 1; // Increment count of w
                end
                if(cycle == 3) begin
                    state <= 2; // Transition to state C
                end
                else begin
                    cycle <= cycle + 1; // Increment cycle counter
                end
            end
            2: begin // State C
                if(count_w == 2) begin
                    z_reg <= 1; // Set z to 1
                end
                else begin
                    z_reg <= 0; // Set z to 0
                end
                state <= 3; // Transition to state D
            end
            3: begin // State D
                state <= 1; // Transition to state B
                count_w <= 0; // Reset count of w
                cycle <= 1; // Reset cycle counter
            end
        endcase
    end
    z <= z_reg; // Assign z_reg to z
end

endmodule