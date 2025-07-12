module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // idle (2'b00), rising (2'b01), falling (2'b10)

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 2'b00; // Initial state is idle
        data_out <= 1'b0; // No pulse detected initially
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data_in) begin
                    state <= 2'b01; // Transition to rising state if data_in is high
                    data_out <= 1'b0; // Not a pulse yet
                end else begin
                    state <= 2'b00; // Stay in idle state
                    data_out <= 1'b0; // Not a pulse
                end
            end
            2'b01: begin // Rising state
                if (data_in) begin
                    state <= 2'b10; // Transition to falling state if data_in remains high
                    data_out <= 1'b0; // Not the end of the pulse yet
                end else begin
                    state <= 2'b00; // Go back to idle state if data_in goes low without a pulse
                    data_out <= 1'b0; // Not a pulse
                end
            end
            2'b10: begin // Falling state
                if (~data_in) begin
                    state <= 2'b00; // Transition back to idle state after detecting a pulse
                    data_out <= 1'b1; // Pulse detected, set data_out to 1
                end else begin
                    state <= 2'b10; // Should not happen in a valid pulse, stay in falling state
                    data_out <= 1'b0; // Not the end of the pulse
                end
            end
            default: begin
                state <= 2'b00; // Any other state, go back to idle
                data_out <= 1'b0; // Not a pulse
            end
        endcase
    end
end

endmodule