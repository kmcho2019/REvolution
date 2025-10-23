module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable to track current state (A or B)
reg [1:0] counter; // Counter to track number of '1's in 'w' over 3 cycles
reg [1:0] cycle_counter; // Counter to track current cycle in 3-cycle window

// Sequential logic for state machine and counters
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // Reset state to A
        counter <= 2'b00; // Reset counter
        cycle_counter <= 2'b00; // Reset cycle counter
        z <= 1'b0; // Reset output 'z'
    end else begin
        case(state)
            2'b01: // State A
                begin
                    if(s) begin
                        state <= 2'b10; // Transition to state B
                        counter <= 2'b00; // Reset counter
                        cycle_counter <= 2'b00; // Reset cycle counter
                    end else begin
                        state <= 2'b01; // Remain in state A
                    end
                end
            2'b10: // State B
                begin
                    if(w) begin
                        counter <= counter + 1; // Increment counter if 'w' is '1'
                    end
                    if(cycle_counter == 2'b11) begin
                        cycle_counter <= 2'b00; // Reset cycle counter
                        state <= 2'b10; // Remain in state B
                    end else begin
                        cycle_counter <= cycle_counter + 1; // Increment cycle counter
                    end
                end
            default: ;
        endcase
    end
end

// Combinational logic for output 'z' evaluation
always @(*) begin
    if(state == 2'b10 && cycle_counter == 2'b11) begin // Only evaluate in state B at end of 3-cycle window
        if(counter == 2'b10) begin // Check if counter value is exactly '2'
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end else begin
        z = 1'b0; // In state A or not at end of 3-cycle window, 'z' is 0
    end
end

endmodule