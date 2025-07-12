module pulse_detect (
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Declare the states
enum logic [1:0] {IDLE, RISING, FALLING} state, next_state;

// Assign the output data_out based on the current state
assign data_out = (state == FALLING)? 1'b1 : 1'b0;

// Always block for sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
    end else begin
        // Pulse detection logic
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state when data_in rises
                    state <= RISING;
                end else begin
                    // Stay in IDLE state if data_in is 0
                    state <= IDLE;
                end
            end
            RISING: begin
                if (~data_in) begin
                    // Transition to FALLING state when data_in falls
                    state <= FALLING;
                end else begin
                    // Stay in RISING state if data_in is 1
                    state <= RISING;
                end
            end
            FALLING: begin
                // Transition back to IDLE state after a pulse is detected
                state <= IDLE;
            end
            default: begin
                // Default state is IDLE
                state <= IDLE;
            end
        endcase
    end
end

endmodule