module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01, State C = 2'b10
reg [1:0] counter; // Counter for consecutive clock cycles
reg [1:0] w_counter; // Counter for 'w' occurrences
reg z_next; // Next value of 'z'

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00; // Reset counter
        w_counter <= 2'b00; // Reset 'w' counter
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to state B
                    counter <= 2'b01; // Initialize counter
                    w_counter <= w ? 2'b01 : 2'b00; // Initialize 'w' counter
                end
            end
            2'b01: begin // State B
                counter <= counter + 1'b1; // Increment counter
                w_counter <= w_counter + w; // Increment 'w' counter
                if(counter == 2'b11) begin // End of window
                    state <= 2'b10; // Transition to state C
                    z_next <= (w_counter == 2'b10) ? 1'b1 : 1'b0; // Set 'z' for next clock cycle
                end
            end
            2'b10: begin // State C
                state <= 2'b01; // Transition back to state B
                counter <= 2'b01; // Reset counter
                w_counter <= w ? 2'b01 : 2'b00; // Reset 'w' counter
                z <= z_next; // Set 'z' to next value
            end
        endcase
    end
end

endmodule