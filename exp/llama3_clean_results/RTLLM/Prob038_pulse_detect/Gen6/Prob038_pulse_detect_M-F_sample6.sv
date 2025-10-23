module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, PULSE_RISING = 2'b01, PULSE_HIGH = 2'b10, PULSE_FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // Reset FSM to IDLE state
        data_out <= 0; // Reset output to zero
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_RISING; // Transition to PULSE_RISING state on 0 to 1
                end
            end
            PULSE_RISING: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_HIGH; // Transition to PULSE_HIGH state if data_in remains 1
                end else begin
                    state <= IDLE; // If data_in goes back to 0 without going high, reset to IDLE
                end
            end
            PULSE_HIGH: begin
                if (data_in == 1'b0) begin
                    state <= PULSE_FALLING; // Transition to PULSE_FALLING state on 1 to 0
                end else begin
                    state <= PULSE_HIGH; // Stay in PULSE_HIGH if data_in remains 1
                end
            end
            PULSE_FALLING: begin
                data_out <= 1; // Set data_out to 1 at the end of the pulse
                state <= IDLE; // Transition back to IDLE state
            end
            default: state <= IDLE; // Default to IDLE for any other state
        endcase
    end
end

always @(posedge clk) begin
    if (state != PULSE_FALLING) begin
        data_out <= 0; // Reset data_out to 0 unless in the PULSE_FALLING state
    end
end

endmodule