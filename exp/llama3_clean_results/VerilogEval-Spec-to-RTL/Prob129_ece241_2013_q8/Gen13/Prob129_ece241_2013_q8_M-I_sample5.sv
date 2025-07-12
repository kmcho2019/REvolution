module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {
    IDLE = 2'b00,
    FIRST_ONE = 2'b01,
    ZERO_AFTER_ONE = 2'b10
} state, next_state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= IDLE;
    end else begin
        // Update the state
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (x) begin
                next_state = FIRST_ONE;
            end
        end
        FIRST_ONE: begin
            if (!x) begin
                next_state = ZERO_AFTER_ONE;
            end else begin
                next_state = FIRST_ONE; // Stay in this state if '1' is received again
            end
        end
        ZERO_AFTER_ONE: begin
            if (x) begin
                next_state = IDLE; // Sequence recognized, reset to IDLE
            end else begin
                next_state = IDLE; // Reset to IDLE if '0' is received again
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic: Assert z when the sequence "101" is detected
assign z = (state == ZERO_AFTER_ONE) && x;

endmodule