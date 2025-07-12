module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // To store the previous value of 'a'
reg state; // State variable for the state machine

always @(posedge clock) begin
    prev_a <= a; // Update the previous value of 'a'
    p <= a; // 'p' is high only when 'a' is high
    
    case (state)
        1'b0: begin // Initial state
            if (a) begin
                state <= 1'b1; // Transition to state 1 if 'a' is high
            end
        end
        1'b1: begin // 'a' has been high for one clock cycle
            if (a) begin
                state <= 1'b2; // Transition to state 2 if 'a' is still high
            end else begin
                state <= 1'b0; // Reset to initial state if 'a' is low
            end
        end
        1'b2: begin // 'a' has been high for two consecutive clock cycles
            q <= 1'b1; // Set 'q' high
            if (!a) begin
                state <= 1'b3; // Transition to state 3 if 'a' goes low
            end
        end
        1'b3: begin // 'q' is high, waiting for clock to go low
            if (!clock) begin
                q <= 1'b1; // Keep 'q' high when clock goes low
            end
            if (a) begin
                state <= 1'b1; // Transition back to state 1 if 'a' is high
            end
        end
        default: state <= 1'b0; // Default to initial state
    endcase
end

initial begin
    prev_a = 1'b0; // Initialize 'prev_a' to 0
    p = 1'b0; // Initialize 'p' to 0
    q = 1'b0; // Initialize 'q' to 0
    state = 1'b0; // Initialize state to 0
end

endmodule