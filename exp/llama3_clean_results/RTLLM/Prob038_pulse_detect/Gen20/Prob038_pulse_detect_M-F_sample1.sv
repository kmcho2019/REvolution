module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM using explicit encoding for control
typedef enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_RISING = 2'b01,
    PULSE_FALLING = 2'b10
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (~rst_n) begin // Synchronous reset for simplicity and potential timing benefits
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= PULSE_RISING;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_RISING: begin
                if (~data_in) begin
                    next_state <= PULSE_FALLING;
                    data_out <= 1; // Set data_out to 1 at the end of a pulse
                end else begin
                    next_state <= PULSE_RISING;
                    data_out <= 0;
                end
            end
            PULSE_FALLING: begin
                next_state <= IDLE;
                data_out <= 0; // Reset data_out after a pulse
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule