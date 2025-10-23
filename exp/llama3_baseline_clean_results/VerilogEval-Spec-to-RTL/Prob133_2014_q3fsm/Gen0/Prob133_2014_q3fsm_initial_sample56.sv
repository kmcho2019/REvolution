module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // Counter for the cycles since entering state B
reg [1:0] w_count; // Counter for the number of times w = 1
reg in_state_b; // Flag to indicate if we are in state B

always @(posedge clk) begin
    if (reset) begin
        // Reset all registers to their initial values
        counter <= 0;
        w_count <= 0;
        in_state_b <= 0;
        z <= 0;
    end else begin
        if (!in_state_b && s) begin
            // Transition from state A to state B
            in_state_b <= 1;
            counter <= 1; // Start counting cycles
            w_count <= w; // Count w in the first cycle
        end else if (in_state_b) begin
            // Logic for state B
            if (counter < 3) begin
                // Still monitoring w
                counter <= counter + 1;
                w_count <= w_count + w;
            end else begin
                // Decide on z
                z <= (w_count == 2) ? 1 : 0;
                // Reset counters for the next monitoring period
                counter <= 1;
                w_count <= w;
            end
        end
    end
end

endmodule