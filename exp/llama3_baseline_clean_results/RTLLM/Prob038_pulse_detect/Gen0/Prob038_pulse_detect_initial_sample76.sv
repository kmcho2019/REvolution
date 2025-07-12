module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states for the FSM
typedef enum logic [1:0] {
    IDLE,
    PULSE_RISING,
    PULSE_FALLING
} state_t;

// Declare the current state register
reg [1:0] state;

// Initialize the output signal
reg data_out_init;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to PULSE_RISING state
                    state <= PULSE_RISING;
                    data_out <= 0;
                end else begin
                    // Stay in IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_RISING: begin
                if (~data_in) begin
                    // Transition to PULSE_FALLING state
                    state <= PULSE_FALLING;
                    data_out <= 0;
                end else begin
                    // Stay in PULSE_RISING state
                    state <= PULSE_RISING;
                    data_out <= 0;
                end
            end
            PULSE_FALLING: begin
                // Set data_out to 1 and transition back to IDLE state
                state <= IDLE;
                data_out <= 1;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule