module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enumerate states for the finite state machine
enum logic [1:0] {
    IDLE,
    RISING,
    PEAK,
    FALLING
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE; // Reset state to IDLE
        data_out <= 0; // Reset output to 0
    end else begin
        state <= next_state; // Update current state
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISING; // Transition to RISING state if data_in is 1
                    data_out <= 0; // Reset output
                end else begin
                    next_state <= IDLE; // Stay in IDLE state if data_in is 0
                    data_out <= 0; // Reset output
                end
            end
            RISING: begin
                if (data_in) begin
                    next_state <= PEAK; // Transition to PEAK state if data_in is still 1
                    data_out <= 0; // Reset output
                end else begin
                    next_state <= IDLE; // Go back to IDLE state if data_in becomes 0 too soon
                    data_out <= 0; // Reset output
                end
            end
            PEAK: begin
                if (!data_in) begin
                    next_state <= FALLING; // Transition to FALLING state if data_in becomes 0
                    data_out <= 1; // Set output to 1, indicating pulse detection
                end else begin
                    next_state <= PEAK; // Stay in PEAK state if data_in remains 1
                    data_out <= 0; // Reset output
                end
            end
            FALLING: begin
                next_state <= IDLE; // Transition back to IDLE state
                data_out <= 0; // Reset output
            end
        endcase
    end
end

endmodule