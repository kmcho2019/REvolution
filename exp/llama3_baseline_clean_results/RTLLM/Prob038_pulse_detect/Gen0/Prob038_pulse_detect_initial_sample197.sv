module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 2'b00; // Initial state
        data_out <= 1'b0; // No pulse indication
    end else begin
        case (state)
            2'b00: begin // Initial state, waiting for the rising edge of the pulse
                if (data_in == 1'b1) begin
                    state <= 2'b01; // Rising edge detected, waiting for the high level of the pulse
                end else begin
                    state <= 2'b00; // Still waiting for the rising edge
                end
                data_out <= 1'b0; // No pulse indication
            end
            2'b01: begin // Rising edge detected, waiting for the high level of the pulse
                if (data_in == 1'b1) begin
                    state <= 2'b10; // High level detected, waiting for the falling edge of the pulse
                end else begin
                    state <= 2'b00; // Pulse cancelled, back to initial state
                end
                data_out <= 1'b0; // No pulse indication
            end
            2'b10: begin // High level detected, waiting for the falling edge of the pulse
                if (data_in == 1'b0) begin
                    state <= 2'b11; // Falling edge detected, output pulse indication signal
                end else begin
                    state <= 2'b10; // Still waiting for the falling edge
                end
                data_out <= 1'b0; // No pulse indication
            end
            2'b11: begin // Falling edge detected, output pulse indication signal
                data_out <= 1'b1; // Pulse indication
                state <= 2'b00; // Back to initial state
            end
        endcase
    end
end

endmodule