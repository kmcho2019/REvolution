module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01
reg [1:0] cycle_counter; // Counter for three clock cycles
reg [1:0] w_counter; // Counter for w = 1 occurrences

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        cycle_counter <= 2'b00;
        w_counter <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to state B
                    cycle_counter <= 2'b01; // Start cycle counter
                    w_counter <= 2'b00; // Reset w counter
                end
            end
            2'b01: begin // State B
                if(cycle_counter == 2'b11) begin // End of three clock cycles
                    if(w_counter == 2'b10) begin // Exactly two w = 1 occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    cycle_counter <= 2'b00; // Reset cycle counter
                    w_counter <= 2'b00; // Reset w counter
                end else begin
                    if(w) begin
                        w_counter <= w_counter + 1'b1; // Increment w counter if w = 1
                    end
                    cycle_counter <= cycle_counter + 1'b1; // Increment cycle counter
                end
            end
            default: begin
                state <= 2'b00; // Default back to state A
            end
        endcase
    end
end

endmodule