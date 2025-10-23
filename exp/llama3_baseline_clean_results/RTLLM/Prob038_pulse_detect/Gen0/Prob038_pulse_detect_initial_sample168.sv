module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,    // Initial state
    RISING,  // State when data_in rises from 0 to 1
    HIGH,    // State when data_in is 1
    FALLING  // State when data_in falls from 1 to 0
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Default output to 0
        data_out <= 0;
        
        // Transition logic
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state when data_in goes from 0 to 1
                    state <= RISING;
                end else begin
                    // Stay in IDLE state if data_in remains 0
                    state <= IDLE;
                end
            end
            
            RISING: begin
                if (data_in) begin
                    // Transition to HIGH state when data_in remains 1
                    state <= HIGH;
                end else begin
                    // If data_in goes back to 0 without being in HIGH state, return to IDLE
                    state <= IDLE;
                end
            end
            
            HIGH: begin
                if (~data_in) begin
                    // Transition to FALLING state when data_in goes from 1 to 0
                    state <= FALLING;
                end else begin
                    // Stay in HIGH state if data_in remains 1
                    state <= HIGH;
                end
            end
            
            FALLING: begin
                // Set data_out to 1 to indicate the end of a pulse
                data_out <= 1;
                // Transition back to IDLE state after a pulse is detected
                state <= IDLE;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule