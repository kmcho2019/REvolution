module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // State variable for the FSM

always @(posedge clock) begin
    case (state)
        2'b00: begin // Initial state
            if (a) begin
                state <= 2'b01; // Transition to state 01 if 'a' is high
            end else begin
                state <= 2'b00; // Stay in state 00 if 'a' is low
            end
        end
        2'b01: begin // 'a' was high in the previous clock cycle
            if (a) begin
                state <= 2'b10; // Transition to state 10 if 'a' is still high
            end else begin
                state <= 2'b00; // Transition back to state 00 if 'a' is low
            end
        end
        2'b10: begin // 'a' has been high for at least two consecutive clock cycles
            if (a) begin
                state <= 2'b10; // Stay in state 10 if 'a' is still high
            end else begin
                state <= 2'b00; // Transition back to state 00 if 'a' is low
            end
        end
        default: begin
            state <= 2'b00; // Default to state 00 for any other state
        end
    endcase
end

always @(negedge clock) begin
    case (state)
        2'b00: begin
            p <= 1'b0; // Reset 'p' in state 00
            q <= 1'b0; // Reset 'q' in state 00
        end
        2'b01: begin
            p <= 1'b0; // Reset 'p' in state 01
            q <= 1'b0; // Reset 'q' in state 01
        end
        2'b10: begin
            p <= 1'b1; // Set 'p' high in state 10
            q <= 1'b1; // Set 'q' high in state 10
        end
        default: begin
            p <= 1'b0; // Default 'p' to 0 for any other state
            q <= 1'b0; // Default 'q' to 0 for any other state
        end
    endcase
end

endmodule