module pulse_detect (
    input           clk,
    input           rst_n,
    input           data_in,
    output          data_out
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    PULSE_RISING,
    PULSE_HIGH,
    PULSE_FALLING
} state, next_state;

// Always block to detect the pulse
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        // Pulse detection logic
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_RISING;
                    data_out <= 1'b0;
                end else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            PULSE_RISING: begin
                if (data_in) begin
                    state <= PULSE_HIGH;
                    data_out <= 1'b0;
                end else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            PULSE_HIGH: begin
                if (~data_in) begin
                    state <= PULSE_FALLING;
                    data_out <= 1'b1;
                end else begin
                    state <= PULSE_HIGH;
                    data_out <= 1'b0;
                end
            end
            PULSE_FALLING: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule