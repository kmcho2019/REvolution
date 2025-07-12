module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg in_state_b; // Flag to indicate if we are in state B
reg [1:0] count_cycle; // Cycle counter
reg [1:0] count_w; // Count of w in three cycles

always @(posedge clk) begin
    if(reset) begin
        in_state_b <= 0; // Reset to state A
        count_cycle <= 0; // Reset cycle counter
        count_w <= 0; // Reset count of w
        z <= 0; // Reset z
    end
    else begin
        if(!in_state_b) begin // State A
            if(s) begin
                in_state_b <= 1; // Transition to state B
                count_cycle <= 1; // Reset cycle counter
                count_w <= 0; // Reset count of w
            end
        end
        else begin // State B
            if(w) begin
                count_w <= count_w + 1; // Increment count of w
            end
            if(count_cycle == 3) begin
                z <= (count_w == 2) ? 1 : 0; // Update z
                in_state_b <= 0; // Transition to state A
                count_cycle <= 0; // Reset cycle counter
                count_w <= 0; // Reset count of w
            end
            else begin
                count_cycle <= count_cycle + 1; // Increment cycle counter
            end
        end
    end
end

endmodule