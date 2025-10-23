module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RISING,
    HIGH,
    FALLING
} state, next_state;

// Always block to handle reset and clock
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Update state and data_out based on current state and data_in
        case (state)
            IDLE: begin
                if (data_in) begin
                    // If data_in is 1, transition to RISING state
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    // If data_in is 0, stay in IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    // If data_in is 1, transition to HIGH state
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // If data_in is 0, transition back to IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (data_in) begin
                    // If data_in is 1, stay in HIGH state
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // If data_in is 0, transition to FALLING state
                    state <= FALLING;
                    data_out <= 1;
                end
            end
            FALLING: begin
                // Transition back to IDLE state
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule