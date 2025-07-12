module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register for FSM: 0 - Idle, 1 - Rising Edge, 2 - Falling Edge
reg prev_data_in; // Store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0; // Reset state to idle
        data_out <= 0; // Reset output
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        case(state)
            0: begin // Idle state
                if (!prev_data_in && data_in) begin // Rising edge detected
                    state <= 1; // Transition to rising edge state
                    data_out <= 0; // No pulse detected yet
                end else begin
                    state <= 0; // Stay in idle
                    data_out <= 0; // No pulse detected
                end
            end
            1: begin // Rising edge detected
                if (prev_data_in && !data_in) begin // Falling edge detected after rising edge
                    state <= 2; // Transition to falling edge state
                    data_out <= 1; // Pulse detected
                end else if (prev_data_in && data_in) begin // Still high after rising edge
                    state <= 1; // Stay in rising edge state
                    data_out <= 0; // No pulse detected yet
                end else begin // Went back low before high was confirmed
                    state <= 0; // Return to idle
                    data_out <= 0; // No pulse detected
                end
            end
            2: begin // Falling edge detected
                state <= 0; // Reset to idle state
                data_out <= 0; // Reset output after pulse detection
            end
            default: begin
                state <= 0; // Default to idle state
                data_out <= 0; // Default output
            end
        endcase
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule