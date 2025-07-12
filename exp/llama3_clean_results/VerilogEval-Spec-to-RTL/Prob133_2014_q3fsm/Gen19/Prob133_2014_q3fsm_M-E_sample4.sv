module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable to track current state (A or B)
reg [1:0] counter; // Counter to track number of '1's in 'w' input
reg [1:0] clock_cycle; // Counter to track clock cycles in state B

// Sequential logic for state machine and counters
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // Reset state to A
        counter <= 2'b00; // Reset counter
        clock_cycle <= 2'b00; // Reset clock cycle counter
        z <= 1'b0; // Reset output 'z'
    end else begin
        case(state)
            2'b01: // State A
                begin
                    if(s) begin
                        state <= 2'b10; // Transition to state B
                        counter <= 2'b00; // Reset counter
                        clock_cycle <= 2'b00; // Reset clock cycle counter
                    end else begin
                        state <= 2'b01; // Remain in state A
                    end
                end
            2'b10: // State B
                begin
                    if(w) begin
                        counter <= counter + 1; // Increment counter if 'w' is 1
                    end
                    clock_cycle <= clock_cycle + 1; // Increment clock cycle counter
                    if(clock_cycle == 2'b11) begin // After three clock cycles
                        state <= 2'b10; // Remain in state B
                        clock_cycle <= 2'b00; // Reset clock cycle counter
                        if(counter == 2'b10) begin // Exactly two '1's detected
                            z <= 1'b1; // Set 'z' to 1
                        end else begin
                            z <= 1'b0; // Set 'z' to 0
                        end
                        counter <= 2'b00; // Reset counter
                    end else begin
                        state <= 2'b10; // Remain in state B
                    end
                end
            default: ;
        endcase
    end
end

endmodule