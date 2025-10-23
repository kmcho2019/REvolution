module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Current state (0: A, 1: B)
reg [1:0] count_cycle; // Cycle counter
reg [1:0] count_w; // Count of w in three cycles
reg z_reg; // Register to hold z value

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state to A
        count_cycle <= 0; // Reset cycle counter
        count_w <= 0; // Reset count of w
        z_reg <= 0; // Reset z
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    count_cycle <= 1; // Reset cycle counter
                    count_w <= 0; // Reset count of w
                end
            end
            1: begin // State B
                if(w) begin
                    count_w <= count_w + 1; // Increment count of w
                end
                if(count_cycle == 3) begin
                    if(count_w == 2) begin
                        z_reg <= 1; // Set z to 1
                    end
                    else begin
                        z_reg <= 0; // Set z to 0
                    end
                    state <= 0; // Transition to state A
                    count_cycle <= 0; // Reset cycle counter
                    count_w <= 0; // Reset count of w
                end
                else begin
                    count_cycle <= count_cycle + 1; // Increment cycle counter
                end
            end
        endcase
    end
    z <= z_reg; // Assign z_reg to z
end

endmodule