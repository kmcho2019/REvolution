module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 1-bit state variable (0 for A, 1 for B)
reg [1:0] counter; // 2-bit counter to track number of '1's in 'w' input
reg [1:0] clock_cycle; // 2-bit counter to track clock cycles in state B

// Sequential logic for state machine and counters
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset state to A
        counter <= 2'b00; // Reset counter
        clock_cycle <= 2'b00; // Reset clock cycle counter
        z <= 1'b0; // Reset output 'z'
    end else begin
        if(state == 1'b0) begin // State A
            if(s) begin
                state <= 1'b1; // Transition to state B
                counter <= 2'b00; // Reset counter
                clock_cycle <= 2'b00; // Reset clock cycle counter
            end
        end else begin // State B
            if(w) begin
                counter <= counter + 1; // Increment counter if 'w' is 1
            end
            clock_cycle <= clock_cycle + 1; // Increment clock cycle counter
            if(clock_cycle == 2'b11) begin // After three clock cycles
                clock_cycle <= 2'b00; // Reset clock cycle counter
                if(counter == 2) begin // Exactly two '1's detected
                    z <= 1'b1; // Set 'z' to 1
                end else begin
                    z <= 1'b0; // Set 'z' to 0
                end
                counter <= 2'b00; // Reset counter
            end
        end
    end
end

endmodule