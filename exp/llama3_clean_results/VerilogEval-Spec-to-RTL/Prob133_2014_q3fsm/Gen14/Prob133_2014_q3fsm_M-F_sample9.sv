module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] cycle_count; // Counter for the three cycles
reg [1:0] w_count; // Counter for w = 1
reg in_state_b; // Flag to indicate if we are in state B

always @(posedge clk) begin
    if(reset) begin
        cycle_count <= 0;
        w_count <= 0;
        in_state_b <= 0;
        z <= 0;
    end
    else begin
        // Transition from state A to state B
        if(!in_state_b && s) begin
            in_state_b <= 1;
            cycle_count <= 1;
            w_count <= 0;
        end
        // Check and update cycle_count and w_count in state B
        else if(in_state_b && cycle_count < 3) begin
            cycle_count <= cycle_count + 1;
            if(w) begin
                w_count <= w_count + 1;
            end
        end
        // Check if three cycles have passed in state B
        else if(in_state_b && cycle_count == 3) begin
            // Check if w_count is 2
            if(w_count == 2) begin
                z <= 1;
            end
            else begin
                z <= 0;
            end
            // Reset cycle_count and w_count for the next check
            cycle_count <= 1;
            w_count <= 0;
        end
        // If we are still in state A, keep z = 0
        else begin
            z <= 0;
        end
    end
end

endmodule