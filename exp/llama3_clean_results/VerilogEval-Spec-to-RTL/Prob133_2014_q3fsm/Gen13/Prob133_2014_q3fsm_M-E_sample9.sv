module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2-bit state variable (A or B)
reg [1:0] counter; // 2-bit counter to track clock cycles
reg [1:0] w_counter; // 2-bit counter to track 'w' occurrences

// Sequential logic for state machine and counters
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to A
        counter <= 2'b00; // Reset clock cycle counter
        w_counter <= 2'b00; // Reset 'w' occurrence counter
        z <= 1'b0; // Reset output z
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to state B
                    counter <= 2'b01; // Initialize clock cycle counter
                    w_counter <= 2'b00; // Initialize 'w' occurrence counter
                end
            end
            2'b01: begin // State B
                counter <= counter + 1; // Increment clock cycle counter
                if(w) begin
                    w_counter <= w_counter + 1; // Increment 'w' occurrence counter
                end
                if(counter == 2'b11) begin // After three clock cycles
                    if(w_counter == 2'b10) begin // Check if 'w' occurred exactly twice
                        z <= 1'b1; // Set 'z' high
                    end else begin
                        z <= 1'b0; // Set 'z' low
                    end
                    state <= 2'b00; // Transition back to state A
                    counter <= 2'b00; // Reset clock cycle counter
                    w_counter <= 2'b00; // Reset 'w' occurrence counter
                end
            end
        endcase
    end
end

endmodule