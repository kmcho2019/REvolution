module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Current state of the FSM

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 0; // Reset state to idle
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            0: begin // Idle state, waiting for 0 to 1 transition
                if (data_in) begin
                    state <= 1; // Transition to waiting for 1 to 0
                end else begin
                    state <= 0; // Stay in idle
                end
                data_out <= 0; // No pulse yet
            end
            1: begin // Waiting for 1 to 0 transition
                if (!data_in) begin
                    state <= 0; // Transition back to idle
                    data_out <= 1; // Pulse detected
                end else begin
                    state <= 1; // Stay waiting
                end
                if (data_in) begin
                    data_out <= 0; // No pulse yet
                end
            end
            default: begin
                state <= 0; // Invalid state, reset to idle
                data_out <= 0; // No pulse
            end
        endcase
    end
end

endmodule