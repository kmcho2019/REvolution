module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // Counter to track the number of clock cycles since entering state B
reg [1:0] w_count; // Counter to count the number of '1's in the 'w' input
reg state; // Current state (0 for A, 1 for B)

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    counter <= 1; // Start counting clock cycles
                    w_count <= w; // Initialize w_count with current 'w' value
                end
                z <= 0;
            end
            1: begin // State B
                counter <= counter + 1; // Increment clock cycle counter
                w_count <= w_count + w; // Increment 'w' counter if 'w' is 1
                if(counter == 3) begin // After 3 clock cycles
                    z <= (w_count == 2); // Set 'z' based on 'w' count
                    state <= 1; // Stay in state B
                    counter <= 1; // Reset clock cycle counter
                    w_count <= w; // Reset 'w' counter with current 'w' value
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule