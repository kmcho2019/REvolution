module pulse_detect(
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state, next_state;

// Always block for state register and output generation
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        // State transitions and output generation
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state when data_in rises
                    state <= RISING;
                end else begin
                    // Stay in IDLE state if data_in is still low
                    state <= IDLE;
                end
                data_out <= 0;
            end
            RISING: begin
                if (data_in) begin
                    // Stay in RISING state if data_in is still high
                    state <= RISING;
                end else begin
                    // Transition to FALLING state when data_in falls
                    state <= FALLING;
                end
                data_out <= 0;
            end
            FALLING: begin
                if (~data_in) begin
                    // Set data_out to 1 and transition to IDLE state
                    data_out <= 1;
                    state <= IDLE;
                end else begin
                    // Transition back to RISING state if data_in rises again
                    state <= RISING;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule